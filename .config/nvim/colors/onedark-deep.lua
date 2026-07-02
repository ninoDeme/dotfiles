for k in pairs(package.loaded) do
    if k:match(".*onedark.*") then package.loaded[k] = nil end
end

require('onedark').setup({style = "deep"})
require('onedark').colorscheme()

vim.g.colors_name = 'onedark-deep'
