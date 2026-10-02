-- Главное меню (стартовый экран)

-- Подстраховка: если в kickstart нет глобального хелпера gh — создаём свой
if not _G.gh then
  _G.gh = function(repo) return 'https://github.com/' .. repo end
end

vim.pack.add {
  gh 'goolord/alpha-nvim',
  gh 'folke/persistence.nvim', -- запоминает сессии (кнопка "Open last session")
}

require('persistence').setup {}

local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'

-- Иконки (нужен Nerd Font, см. примечание ниже)
local icon = {
  file     = '\u{f15b}', -- документ
  search   = '\u{f002}', -- лупа
  history  = '\u{f1da}', -- часы
  bookmark = '\u{f02e}', -- закладка
  session  = '\u{f0c7}', -- дискета
  exit     = '\u{f08b}', -- выход
}

-- ── Цвета ─────────────────────────────────────────────────────
local function apply_hl()
  vim.api.nvim_set_hl(0, 'AlphaLogo', { fg = '#b8bb26', italic = true }) -- лого, оливковый как на скрине
  vim.api.nvim_set_hl(0, 'AlphaText', { fg = '#a89984' })                -- пункты меню
  vim.api.nvim_set_hl(0, 'AlphaKeys', { fg = '#fb4934', bold = true })   -- шорткаты справа, красные
  vim.api.nvim_set_hl(0, 'AlphaFoot', { fg = '#928374', italic = true }) -- подвал
end
apply_hl()
-- чтобы цвета не слетали при загрузке/смене цветовой схемы
vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_hl })

-- ── Логотип ───────────────────────────────────────────────────
dashboard.section.header.val = {
  '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
  '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
  '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
  '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
  '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
  '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
}
dashboard.section.header.opts.hl = 'AlphaLogo'
dashboard.section.header.opts.position = 'center'

-- ── Кнопки ────────────────────────────────────────────────────
dashboard.section.buttons.val = {
  dashboard.button('SPC ff', icon.file .. '  Find file',             ':Telescope find_files <CR>'),
  dashboard.button('SPC fg', icon.search .. '  Find word',           ':Telescope live_grep <CR>'),
  dashboard.button('SPC fr', icon.history .. '  Recently opened',    ':Telescope oldfiles <CR>'),
  dashboard.button('SPC fb', icon.bookmark .. '  Jump to bookmarks', ':Telescope marks <CR>'),
  dashboard.button('SPC fs', icon.session .. '  Open last session',
    function() require('persistence').load { last = true } end),
  dashboard.button('SPC q',  icon.exit .. '  Quit',                  ':qa<CR>'),
}

-- стиль кнопок: текст слева, шорткаты справа, без скобок
for _, btn in ipairs(dashboard.section.buttons.val) do
  btn.opts.hl = 'AlphaText'
  btn.opts.hl_shortcut = 'AlphaKeys'
  btn.opts.align_shortcut = 'right'
  btn.opts.shortcut = btn.opts.shortcut:gsub('%[', ''):gsub('%]', '')
end

-- ── Подвал: надпись neovim курсивом ───────────────────────────
local v = vim.version()
dashboard.section.footer.val = ('neovim v%d.%d.%d'):format(v.major, v.minor, v.patch)
dashboard.section.footer.opts.hl = 'AlphaFoot'
dashboard.section.footer.opts.position = 'center'

alpha.setup(dashboard.opts)
