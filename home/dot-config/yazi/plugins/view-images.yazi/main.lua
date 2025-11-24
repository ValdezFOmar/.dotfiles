local M = {}

---@class Images
---@field paths string[]
---@field start_at integer

---@type fun(): Images
local get_images = ya.sync(function()
    local images = { paths = {}, start_at = 1 } ---@type Images
    local directory = cx.active.current
    local hovered_filename = directory.hovered and directory.hovered.name
    for _, file in ipairs(directory.files) do
        local mime = file:mime()
        if mime and mime:sub(1, 5) == 'image' then
            table.insert(images.paths, tostring(file.url))
            if hovered_filename == file.name then
                images.start_at = #images.paths
            end
        end
    end
    return images
end)

---@param images Images
---@return Status
local function view_images(images)
    local child = assert(
        Command('nsxiv')
            :arg('--null')
            :arg('--stdin')
            :arg('--no-bar')
            :arg('--animate')
            :arg('--start-at')
            :arg(tostring(images.start_at))
            :stdin(Command.PIPED)
            :spawn()
    )
    assert(child:write_all(table.concat(images.paths, '\0')))
    assert(child:flush())
    local status = assert(child:wait())
    return status
end

function M.entry()
    local images = get_images()
    if #images.paths == 0 then
        ya.notify { title = 'View-images', content = 'No images to view', timeout = 3 }
        return
    end
    local status = view_images(images)
    if not status.success then
        ya.notify {
            title = 'View-images',
            content = ('`nsxiv` exit with code %d'):format(status.code),
            timeout = 5,
            level = 'error',
        }
    end
end

return M
