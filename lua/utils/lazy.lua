local M = {}

function M.with_module(module, action, missing_message)
    return function()
        local ok, mod = pcall(require, module)
        if not ok then
            if missing_message then
                vim.notify(missing_message, vim.log.levels.WARN)
            end
            return
        end
        action(mod)
    end
end


function M.with_conform(action)
    return M.with_module('conform', action, 'conform is not available')
end

return M
