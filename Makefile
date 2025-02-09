.PHONY: all
.PHONY: fixups
.PHONY: clean

OUTPUT_DIR=nethsm
TARGET_MODULE=github.com/borud/nethsm
GIT_REPOSITORY=git@github.com:borud/nethsm.git

all: prepare generate fixups

prepare:
	@rm -rf ${OUTPUT_DIR}
	@git clone ${GIT_REPOSITORY}
	@rm -rf ${OUTPUT_DIR}/* 
	@rm -rf ${OUTPUT_DIR}/.openapi-generator* 
	@rm -rf ${OUTPUT_DIR}/.travis.yml 
	@rm -rf ${OUTPUT_DIR}/.gitignore
	@cp LICENSE ${OUTPUT_DIR}/.

generate:
	docker run --rm -ti \
		-v "${PWD}:/local" \
		openapitools/openapi-generator-cli generate \
		-i https://nethsmdemo.nitrokey.com/api_docs/nethsm-api.yaml \
		-o /local/${OUTPUT_DIR} \
		-g go \
		--package-name nethsm \
		--additional-properties=gitUserId=borud,gitRepoId=nethsm,enumClassPrefix=true

fixups:
	# Fix the module name in go.mod (cross-platform)
	@echo "Fixing go.mod module name..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		sed -i '' 's|^module github.com/GIT_USER_ID/GIT_REPO_ID|module ${TARGET_MODULE}|' nethsm/go.mod; \
	else \
		sed -i 's|^module github.com/GIT_USER_ID/GIT_REPO_ID|module ${TARGET_MODULE}|' nethsm/go.mod; \
	fi

	# Fix import path in test files
	@echo "Fixing import path in api_default_test.go..."
	@if [ -f nethsm/test/api_default_test.go ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			sed -i '' 's|openapiclient "github.com/GIT_USER_ID/GIT_REPO_ID"|openapiclient "${TARGET_MODULE}"|' nethsm/test/api_default_test.go; \
		else \
			sed -i 's|openapiclient "github.com/GIT_USER_ID/GIT_REPO_ID"|openapiclient "${TARGET_MODULE}"|' nethsm/test/api_default_test.go; \
		fi \
	fi

	# Run go mod tidy to clean up dependencies
	@echo "Running go mod tidy..."
	@cd nethsm && go mod tidy
	@echo "✅ Fixes applied successfully."

clean:
	rm -rf ${OUTPUT_DIR}
