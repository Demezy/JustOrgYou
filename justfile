set export

crate := "native"

@codegen:
  flutter pub get
  flutter_rust_bridge_codegen \
    -r $crate/src/api.rs \
    -d lib/bridge_generated.dart \
    -c ios/Runner/bridge_generated.h \
    -e macos/Runner/ \
    --dart-decl-output lib/bridge_definitions.dart

remove-gen:
  # replace fd with find
  fd -tf bridge_generated -x rm -rf

remove-build:
  cd $crate && cargo clean

clean: remove-gen remove-build
  flutter clean

run: codegen
  flutter run

run-no-cache: clean codegen run
