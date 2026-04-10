math.randomseed(os.time())

function _G.insert_finsim_id_field()
    vim.ui.input({ prompt = "Prefix: " }, function(prefix)
        if not prefix or prefix == "" then return end

        local hex = ""
        for _ = 1, 8 do
            hex = hex .. string.format("%x", math.random(0, 15))
        end

        local line = string.format('"id": "%s_%s",', prefix, hex)

        vim.api.nvim_put({ line }, "l", true, true)
    end)
end

vim.keymap.set("n", "<leader>id", _G.insert_finsim_id_field, { desc = "Insert finsim ID" })
