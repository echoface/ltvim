local ok, gopher = pcall(require, "gopher")
if not ok then
    return
end

gopher.setup {
    commands = {
        go = "go",
        dlv = "dlv",
        impl = "impl",
        iferr = "iferr",
        gotests = "gotests",
        gomodifytags = "gomodifytags",
    },
    gotests = {
        -- gotests doesn't have template named "default" so this plugin uses "default" to set the default template
        template = "default",
        -- path to a directory containing custom test code templates
        template_dir = nil,
        -- switch table tests from using slice to map (with test name for the key)
        -- works only with gotests installed from develop branch
        named = false,
    },
    gotag = {
        transform = "snakecase",
    },
}
