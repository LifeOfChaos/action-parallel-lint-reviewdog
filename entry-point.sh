#!/bin/sh

cd "${GITHUB_WORKSPACE}/${WORKDIR}" || exit 1

TEMP_PATH="$(mktemp -d)"
PREV_PATH=$PATH
PATH="${TEMP_PATH}:$PATH"
export REVIEWDOG_GITHUB_API_TOKEN="${GITHUB_TOKEN}"

echo '::group:: Installing reviewdog 🐶... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "latest" 2>&1
echo '::endgroup::'

echo '::group:: parallel-lint'
echo "Using: $(./vendor/bin/parallel-lint --version)"
echo '::endgroup::'

echo '::group:: Running parallel-lint with reviewdog 🐶...'
if [ "${REVIEWDOG_REPORTER}" = 'github-pr-review' ]; then
  composer run "${COMPOSER_COMMAND}" \
      | jq -r ' .results.errors | to_entries[] | .value as $data | $data.file as $path | "\($path):\($data.line):0:`error: \($data.type)`<br/>\($data.normalizeMessage)"' \
      | reviewdog -efm="%f:%l:%c:%m" -name="parallel-lint" -reporter="${REVIEWDOG_REPORTER}" -filter-mode="${REVIEWDOG_FILTER_MODE}" -fail-on-error="${REVIEWDOG_FAIL_ON_ERROR}" -level="${REVIEWDOG_LEVEL}"
  else
    composer run "${COMPOSER_COMMAND}" \
      | reviewdog -f="checkstyle" -name="parallel-lint" -reporter="${REVIEWDOG_REPORTER}" -filter-mode="${REVIEWDOG_FILTER_MODE}" -fail-on-error="${REVIEWDOG_FAIL_ON_ERROR}" -level="${REVIEWDOG_LEVEL}"
fi

output=$?
echo '::endgroup::'

echo '::group:: Removing rewiewdog 🐶 files...'
PATH="$PREV_PATH"
rm -rf "$TEMP_PATH"
echo '::endgroup::'

exit $output
