local M = {}

---@class Images
---@field paths string[]
---@field start_at integer

---@type fun(): Images
local get_images = ya.sync(function()
    local images = { paths = {}, start_at = 1 } ---@type Images
    local directory = cx.active.current
    for _, file in ipairs(directory.files) do
        ---@cast file fs__File
        local mime = file:mime()
        if mime and mime:sub(1, 5) == 'image' then
            table.insert(images.paths, tostring(file.url))
            if file.is_hovered then
                images.start_at = #images.paths
            end
        end
    end
    return images
end)

---@param images Images
---@return Status
local function view_images(images)
    local cmd = Command('nsxiv')
        :arg('--null')
        :arg('--stdin')
        :arg('--animate')
        :arg('--start-at')
        :arg(tostring(images.start_at))
        :stdin(Command.PIPED)
    local child = assert(cmd:spawn())
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
            content = ('`nsxiv` exit with code %s'):format(status.code),
            timeout = 5,
            level = 'error',
        }
    end
end

return M
