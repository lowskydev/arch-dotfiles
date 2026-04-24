-- =============================================================================
-- CUSTOM SNIPPETS
-- =============================================================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Markdown code block snippets
ls.add_snippets("markdown", {
  s("crust",   { t({ "```rust", "" }),       i(1), t({ "", "```" }) }),
  s("cc",      { t({ "```c", "" }),           i(1), t({ "", "```" }) }),
  s("ccpp",    { t({ "```cpp", "" }),         i(1), t({ "", "```" }) }),
  s("cpy",     { t({ "```python", "" }),      i(1), t({ "", "```" }) }),
  s("cjava",   { t({ "```java", "" }),        i(1), t({ "", "```" }) }),
  s("cjs",     { t({ "```javascript", "" }), i(1), t({ "", "```" }) }),
  s("cts",     { t({ "```typescript", "" }), i(1), t({ "", "```" }) }),
  s("cbash",   { t({ "```bash", "" }),        i(1), t({ "", "```" }) }),
  s("cgo",     { t({ "```go", "" }),          i(1), t({ "", "```" }) }),
  s("clua",    { t({ "```lua", "" }),         i(1), t({ "", "```" }) }),
  s("cdocker", { t({ "```dockerfile", "" }), i(1), t({ "", "```" }) }),
  s("chtml",   { t({ "```html", "" }),        i(1), t({ "", "```" }) }),
  s("ccss",    { t({ "```css", "" }),         i(1), t({ "", "```" }) }),
  s("ctoml",   { t({ "```toml", "" }),        i(1), t({ "", "```" }) }),
  s("cyaml",   { t({ "```yaml", "" }),        i(1), t({ "", "```" }) }),
  s("cjson",   { t({ "```json", "" }),        i(1), t({ "", "```" }) }),
  s("cblock",  {
    t("```"), i(1, "language"),
    t({ "", "" }), i(2),
    t({ "", "```" }),
  }),
})

-- Markdown GitHub alert snippets
ls.add_snippets("markdown", {
  s("man", { t("> [!NOTE] "),      i(1), t({ "", "> " }), i(2) }),
  s("mat", { t("> [!TIP] "),       i(1), t({ "", "> " }), i(2) }),
  s("mai", { t("> [!IMPORTANT] "), i(1), t({ "", "> " }), i(2) }),
  s("maw", { t("> [!WARNING] "),   i(1), t({ "", "> " }), i(2) }),
  s("mac", { t("> [!CAUTION] "),   i(1), t({ "", "> " }), i(2) }),
})

ls.filetype_extend("text", { "markdown" })
