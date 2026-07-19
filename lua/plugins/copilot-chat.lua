local function add_context(resource)
  return function()
    require("CopilotChat").open()
    vim.schedule(function()
      vim.cmd("stopinsert")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("A" .. resource .. " ", true, false, true), "n", true)
    end)
  end
end

return {
  "CopilotChat.nvim",
  opts = {
    model = "auto", -- account's models list only exposes "auto"; the plugin's "gpt-5-mini" default 404s
    prompts = {
      PR = {
        prompt = [[
Draft and open a pull request for the changes on the current branch.

1. Check the current branch name, its recent commit messages, and diff/log against the base branch (origin/main, falling back to origin/master).
2. Identify the project's unit test command (check package.json scripts, Makefile, pytest/cargo/go conventions, or README/CI config).
3. For every changed function/behavior in the diff that lacks a corresponding unit test, write one that asserts on real outputs/state and would actually fail if the behavior regressed. Do not skip this — untested changes are not allowed in the PR.
4. Run the full unit test suite. When a test fails:
   - Root-cause it first: is the implementation wrong, or did the diff intentionally change this behavior?
   - If the implementation is wrong, fix the implementation. Do not edit the test to accommodate a bug.
   - Only change a test's expectation when the diff deliberately changed that behavior, and call this out explicitly in the Validation section.
   - Never make a test pass by weakening/deleting assertions, skipping or removing test cases, mocking out the code under test, or loosening tolerances/timeouts — that's hiding the bug, not fixing it.
   Rerun until the suite passes for real reasons. Do not proceed to step 5 until it's genuinely green.
5. If there are unpushed commits (including any new test files), push the branch (git push -u origin HEAD).
6. Open the PR with the GitHub CLI (`gh pr create`): title under 70 characters, and a body with exactly these sections:
   - "## Summary" — bullet points describing what changed and why
   - "## Ticket" — the issue/ticket reference if one can be found in the branch name (e.g. `feature/ABC-1234-...`) or a commit message; otherwise write "N/A"
   - "## Validation" — the exact test command run, confirmation the full suite passed, a bullet list of new/updated tests and what each one actually verifies, and an explicit note of any test whose expectation was changed (and why that's a correct behavior change, not a workaround)
7. Report back the PR URL.

Ask me before pushing or creating the PR if the base branch, remote, or scope is unclear, or if you're unsure whether a failing test reflects a real bug versus an intentional behavior change — don't guess. Never open the PR while any test is failing, any changed behavior is untested, or any test was altered just to make it pass.
]],
        tools = { "copilot" }, -- bash + edit + file + glob + grep + gitdiff — needs edit/file access to write missing tests, not just run commands; trusted_tools is unset, so each call still needs manual approval in the chat
        resources = { "gitdiff", "gitdiff:staged" },
      },
    },
  },
  -- merges with LazyVim's ai/copilot-chat extra keys (<leader>aa/ax/aq/ap)
  keys = {
    { "<leader>ab", add_context("#buffer"), desc = "Add Buffer to Context (CopilotChat)", mode = "n" },
    { "<leader>as", add_context("#selection"), desc = "Add Selection to Context (CopilotChat)", mode = "x" },
  },
}
