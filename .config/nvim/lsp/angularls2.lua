---@diagnostic disable: redefined-local
local root_dir = vim.fn.getcwd()
local node_modules_dir = vim.fs.find('node_modules', { path = root_dir, upward = true })[1]
local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir) or '?'

local function get_probe_dir(root)
  return root and (root .. '/node_modules') or ''
end

local default_probe_dir = get_probe_dir(project_root)

-- structure should be like
-- - $EXTENSION_PATH
--   - @angular
--     - language-server
--       - bin
--         - ngserver
--   - typescript
local ngserver_exe = vim.fn.exepath('ngserver')
local ngserver_path = #(ngserver_exe or '') > 0 and vim.fs.dirname(vim.uv.fs_realpath(ngserver_exe)) or '?'
local extension_path = vim.fs.normalize(vim.fs.joinpath(ngserver_path, '../../../'))

-- angularls will get module by `require.resolve(PROBE_PATH, MODULE_NAME)` of nodejs
local ts_probe_dirs = vim.iter({ extension_path, default_probe_dir }):join(',')
local ng_probe_dirs = vim
    .iter({ extension_path, default_probe_dir })
    :map(function(p)
      return vim.fs.joinpath(p, '/@angular/language-server/node_modules')
    end)
    :join(',')

return {
  cmd = {
    'ngserver',
    '--stdio',
    '--tsProbeLocations',
    ts_probe_dirs,
    '--ngProbeLocations',
    ng_probe_dirs,
    -- '--angularCoreVersion',
    -- default_angular_core_version,
  },
  filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
  root_markers = { 'angular.json', 'nx.json' },
  before_init = function(params, config)
    local new_root_dir = params.rootPath
    local node_modules_dir = vim.fs.find('node_modules', { path = new_root_dir, upward = true })[1]
    -- if node_modules_dir == nil then
    --   node_modules_dir = vim.fs.find('angular.json', { path = root_dir, upward = false })[1]
    -- end
    local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir) or '?'

    local function get_angular_core_version()
      if not project_root then
        return ''
      end

      local package_json = project_root .. '/package.json'
      if not vim.uv.fs_stat(package_json) then
        return ''
      end

      local contents = io.open(package_json):read '*a'
      local json = vim.json.decode(contents)
      if not json.dependencies then
        return ''
      end

      local angular_core_version = json.dependencies['@angular/core']

      angular_core_version = angular_core_version and angular_core_version:match('%d+%.%d+%.%d+')

      return angular_core_version
    end

    local default_probe_dir = get_probe_dir(project_root)
    local default_angular_core_version = get_angular_core_version()

    -- structure should be like
    -- - $EXTENSION_PATH
    --   - @angular
    --     - language-server
    --       - bin
    --         - ngserver
    --   - typescript
    local ngserver_exe = vim.fn.exepath('ngserver')
    local ngserver_path = #(ngserver_exe or '') > 0 and vim.fs.dirname(vim.uv.fs_realpath(ngserver_exe)) or '?'
    local extension_path = vim.fs.normalize(vim.fs.joinpath(ngserver_path, '../../../'))

    -- angularls will get module by `require.resolve(PROBE_PATH, MODULE_NAME)` of nodejs
    local ts_probe_dirs = vim.iter({ extension_path, default_probe_dir }):join(',')
    local ng_probe_dirs = vim
        .iter({ extension_path, default_probe_dir })
        :map(function(p)
          return vim.fs.joinpath(p, '/@angular/language-server/node_modules')
        end)
        :join(',')
    config.cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      ts_probe_dirs,
      '--ngProbeLocations',
      ng_probe_dirs,
      '--angularCoreVersion',
      default_angular_core_version,
    }
  end,
}
