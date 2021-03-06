module(..., package.seeall)


--------------------------------------------------------------------------------
-- Requires
--------------------------------------------------------------------------------
local FpsMonitor = require "hp/util/FpsMonitor"
local Component = require "hp/gui/Component"


--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
local SCENE_ITEMS = {
    {text = "scene1",           scene = "scenes/scene1",        animation = "slideToLeft"},
    {text = "scene2",           scene = "scenes/scene2",        animation = "slideToLeft"},
}

local fpsMonitor = FpsMonitor(10)


--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------
function onCreate(params)
    MOAISim.setHistogramEnabled(true)

    createBackgroundLayer()
    createGuiView()
    fpsMonitor:play()
end

function onButtonClick(e)
    MOAISim.forceGarbageCollection()
    MOAISim.reportHistogram()

    local target = e.target
    local item = target and target.item or nil
    if item then
        local childScene = SceneManager:openScene(item.scene, {animation = item.animation})
        createBackButton(childScene)
    end
end

function onBackButtonClick(e)
    SceneManager:closeScene({animation = "slideToRight"})

    MOAISim.forceGarbageCollection()
    MOAISim.reportHistogram()
end

function onExitButtonClick(e)
    os.exit(0)
end


--------------------------------------------------------------------------------
-- Layer Creation
--------------------------------------------------------------------------------
function createBackgroundLayer()
    -- General background
    backgroundLayer = Layer {}

    backgroundSprite = BackgroundSprite {
        texture = "assets/background.png",
        layer = backgroundLayer,
    }

    SceneManager:addBackgroundLayer(backgroundLayer)
end

function createGuiView()
    -- Main UI
    guiView = View {
        scene = scene,
    }

    scroller = Scroller {
        parent = guiView,
        hBounceEnabled = false,
        layout = VBoxLayout {
            align = {"center", "top"},
            padding = {10, 10, 10, 10},
            gap = {10, 10},
        },
    }

    createTitleBarButton("whatever", scroller)

    titleLabel = TextLabel {
        text = "Dynlab Hanappe Test",
        size = {guiView:getWidth(), 50},
        color = {0, 0, 0},
        parent = scroller,
        align = {"center", "center"},
    }

    exitButton = Button {
        text = "Exit",
        size = {100, 50},
        parent = scroller,
        onClick = onExitButtonClick,
    }

    for i, item in ipairs(SCENE_ITEMS) do
        local button = createButton(item.text, scroller)
        button.item = item
    end

end

function createTitleBarButton(text, parent)
    local button = Button {
        text = text,
        size = {200, 50},
        parent = parent
    }

    return button
end

function createButton(text, parent)
    -- Creates a generic button
    local button = Button {
        text = text,
        size = {200, 50},
        parent = parent,
        onClick = onButtonClick,
    }
    return button
end

function createBackButton(parentScene)
    -- Creates a back-button in a specified scene
    local view = View {
        scene = parentScene,
    }
    local button = Button {
        text = "Back",
        alpha = 0.8,
        size = {100, 50},
        parent = view,
        onClick = onBackButtonClick,
    }
    button:setRight(view:getWidth())
    return button
end
