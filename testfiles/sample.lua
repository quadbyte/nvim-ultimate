-- Sample Lua file for testing Neovim Ultimate Edition
-- This file demonstrates syntax highlighting, LSP features, and more

local M = {}

-- Function with documentation
---@param name string The name to greet
---@return string The greeting message
function M.greet(name)
    return "Hello, " .. name .. "!"
end

-- Table with nested structure
M.config = {
    enabled = true,
    options = {
        timeout = 1000,
        retry = 3,
    },
    callbacks = {
        on_success = function()
            print("Success!")
        end,
        on_error = function(err)
            print("Error: " .. tostring(err))
        end,
    },
}

-- Class-like structure
local User = {}
User.__index = User

function User.new(name, email)
    local self = setmetatable({}, User)
    self.name = name
    self.email = email
    return self
end

function User:get_display_name()
    return self.name .. " <" .. self.email .. ">"
end

M.User = User

return M
