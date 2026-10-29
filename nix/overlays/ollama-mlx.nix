final: prev:

let
  mlxSource = final.fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx";
    rev = "97029597882f674a596958bc71fdec3213ccc192";
    hash = "sha256-Kx/yxfnPHeLzktsxfTAuVNzhWmfuibkRMY2HJRomiAs=";
  };

  mlxCSource = final.fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx-c";
    rev = "a341b4925024b88b2c593468f16e12f5e17315da";
    hash = "sha256-OJobebuECqdNdXgwZQh9fSQNt5FJzg7RnFFwj5x/Lhg=";
  };

  xgrammarSource = final.fetchFromGitHub {
    owner = "mlc-ai";
    repo = "xgrammar";
    rev = "v0.2.7";
    fetchSubmodules = true;
    hash = "sha256-1+xL0S/AbrKi+6/pJQvh2b03R5HM04mzazVe7k4jxVg=";
  };

  metalCppSource = final.fetchzip {
    url = "https://developer.apple.com/metal/cpp/files/metal-cpp_26.zip";
    stripRoot = false;
    hash = "sha256-zTJOzsLn4a3iWJUTzOAj/QpUCgRb5gU0/XQxmrHTH0Y=";
  };

  jsonSource = final.fetchzip {
    url = "https://github.com/nlohmann/json/releases/download/v3.11.3/json.tar.xz";
    hash = "sha256-cnGfiVhXzqfj5Fay823wntWcTnbh8r2SefDLslb1Dh0=";
  };

  fmtSource = final.fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "12.1.0";
    hash = "sha256-ZmI1Dv0ZabPlxa02OpERI47jp7zFfjpeWCy1WyuPYZ0=";
  };

  xcrunWrapper = final.writeShellScriptBin "xcrun" ''
    args=("$@")
    for ((i = 0; i < ''${#args[@]}; i++)); do
      if [[ "''${args[$i]}" != metal ]]; then
        continue
      fi

      shopt -s nullglob
      metalTools=(
        /var/run/com.apple.security.cryptexd/mnt/com.apple.MobileAsset.MetalToolchain-*/Metal.xctoolchain/usr/bin/metal
      )
      if (( ''${#metalTools[@]} != 1 )); then
        echo "expected one installed Metal Toolchain, found ''${#metalTools[@]}" >&2
        exit 1
      fi

      if [[ " $* " == *" --find "* || " $* " == *" -f "* ]]; then
        echo "''${metalTools[0]}"
        exit 0
      fi
      exec "''${metalTools[0]}" "''${args[@]:i+1}"
    done

    exec /usr/bin/xcrun "$@"
  '';
in
{
  ollama =
    assert final.lib.assertMsg (
      prev.ollama.version == "0.40.4"
    ) "ollama-mlx overlay must be updated for Ollama ${prev.ollama.version}";
    prev.ollama.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ final.zsh ];

      postPatch = oldAttrs.postPatch + ''
        substituteInPlace cmake/local.cmake \
          --replace-fail \
            'find_program(_ollama_xcrun xcrun)' \
            'set(_ollama_xcrun ${xcrunWrapper}/bin/xcrun)' \
          --replace-fail \
            'ollama_check_metal_toolchain(_metal_version)' \
            'set(_metal_version "$ENV{OLLAMA_METAL_VERSION}")' \
          --replace-fail \
            '        -DFETCHCONTENT_SOURCE_DIR_MLX-C=''${OLLAMA_MLX_C_SOURCE_DIR}' \
            $'        -DFETCHCONTENT_SOURCE_DIR_MLX-C=''${OLLAMA_MLX_C_SOURCE_DIR}\n        -DFETCHCONTENT_SOURCE_DIR_METAL_CPP=${metalCppSource}/metal-cpp\n        -DFETCHCONTENT_SOURCE_DIR_JSON=${jsonSource}\n        -DFETCHCONTENT_SOURCE_DIR_FMT=${fmtSource}'

        cp -R ${mlxSource} "$TMPDIR/mlx-src"
        cp -R ${mlxCSource} "$TMPDIR/mlx-c-src"
        chmod -R u+w "$TMPDIR/mlx-src" "$TMPDIR/mlx-c-src"
        substituteInPlace "$TMPDIR/mlx-src/CMakeLists.txt" \
          --replace-fail 'COMMAND sw_vers -productVersion' 'COMMAND /usr/bin/sw_vers -productVersion'
      '';

      preBuild = ''
        export PATH=${xcrunWrapper}/bin:$PATH
        OLLAMA_METAL_VERSION=$(printf '__METAL_VERSION__\n' | xcrun -sdk macosx metal -E -x metal -P - | tail -1)
        if [[ ! $OLLAMA_METAL_VERSION =~ ^[0-9]+$ ]]; then
          echo "failed to detect the Xcode Metal Toolchain" >&2
          exit 1
        fi
        export OLLAMA_METAL_VERSION
      ''
      +
        builtins.replaceStrings
          [ ''-DOLLAMA_MLX_BACKENDS=""'' ]
          [
            (builtins.concatStringsSep "\n" [
              ''-DOLLAMA_MLX_BACKENDS=metal_v3 \''
              ''-DFETCHCONTENT_SOURCE_DIR_MLX="$TMPDIR/mlx-src" \''
              ''-DFETCHCONTENT_SOURCE_DIR_MLX-C="$TMPDIR/mlx-c-src" \''
              "  -DFETCHCONTENT_SOURCE_DIR_XGRAMMAR=${xgrammarSource}"
            ])
          ]
          oldAttrs.preBuild;

      # MLX's Metal kernels require Apple's proprietary compiler. Newer Xcode
      # exposes it from a dynamically mounted MobileAsset/Cryptex path, so a
      # fixed allowlist is not possible. Network and host writes remain
      # sandboxed, and Homebrew paths are explicitly blocked.
      sandboxProfile = oldAttrs.sandboxProfile + ''
        (allow file-read* process-exec mach-lookup)
        (deny file-read* process-exec
          (subpath "/opt/homebrew")
          (subpath "/usr/local")
          (with no-log))
      '';
    });
}
