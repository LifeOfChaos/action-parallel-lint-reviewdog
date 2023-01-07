# GitHub Action: Run phpcs with reviewdog

This action runs [parallel-lint](https://github.com/php-parallel-lint/PHP-Parallel-Lint) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests.

## Inputs

### `github_token`

**Required**. Your Github token. 
Default is `${{ github.token }}`.

### `level`

Optional. Report level for reviewdog.
Default: `error`.
Values: `info`, `warning`, `error`.

### `reporter`
Optional. Reporter of reviewdog command. 
Default is `github-pr-review`.
Values: `github-check`, `github-pr-review`.

### `filter_mode`

Optional. Filtering mode for the reviewdog command. 
Default is `added`.
Values: `added`, `diff_context`, `file`, `nofilter`

### `fail_on_error`

Optional. Exit code for reviewdog when errors are found. 
Default is `false`.
Valies: `true`, `false`.

### `composer_command`

Optional. Your package script name. `composer run "composer_command"` will be executed. 
Default is `parallel-lint`.

### `workdir`

Optional. Working directory. Default '.'

## Example usage

```yml
name: PHPCS

on:
  pull_request:
jobs:
  stylelint:
    name: PHPCS
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: LifeOfChaos/action-parallel-lint-reviewdog@v1
        name: Running parallel-lint with Reviewdog 🐶
        with:
          reporter: github-pr-review
          github_token: ${{ secrets.GITHUB_TOKEN }}
          level: 'error'
          composer_command: 'lint'
```
