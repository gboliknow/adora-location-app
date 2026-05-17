.PHONY: get clean run run-debug build-apk build-apk-release build-ios build-ios-release \
        test test-coverage analyze format fix gen-l10n runner runner-watch

# ── Dependencies ──────────────────────────────────────────────────────────────

get:
	flutter pub get

upgrade:
	flutter pub upgrade

# ── Dev ───────────────────────────────────────────────────────────────────────

run:
	flutter run

run-debug:
	flutter run --debug

# ── Build ─────────────────────────────────────────────────────────────────────

build-apk:
	flutter build apk --debug

build-apk-release:
	flutter build apk --release

build-ios:
	flutter build ios --debug --no-codesign

build-ios-release:
	flutter build ios --release

# ── Test & Quality ────────────────────────────────────────────────────────────

test:
	flutter test

test-coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

analyze:
	flutter analyze

format:
	dart format lib/ test/

fix:
	dart fix --apply

# ── Codegen ───────────────────────────────────────────────────────────────────

gen-l10n:
	flutter gen-l10n

# Run once (add when `codegen` segment is present)
runner:
	dart run build_runner build --delete-conflicting-outputs

# Watch mode (add when `codegen` segment is present)
runner-watch:
	dart run build_runner watch --delete-conflicting-outputs

# ── Maintenance ───────────────────────────────────────────────────────────────

clean:
	flutter clean && flutter pub get
