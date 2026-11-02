import Meta from 'gi://Meta';
import Shell from 'gi://Shell';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

const BINDINGS = {
    '<Super>Left': [-1, 0],
    '<Super>Right': [1, 0],
    '<Super>Up': [0, -1],
    '<Super>Down': [0, 1],
};

// Focus the window nearest to the focused one in direction (dx, dy). Candidates
// must lie past the focused window's centre; misalignment on the other axis
// counts double so aligned neighbours win over closer diagonal ones.
function focusNeighbour(dx, dy) {
    const current = global.display.focus_window;
    const workspace = global.workspace_manager.get_active_workspace();
    const windows = global.display.get_tab_list(Meta.TabList.NORMAL, workspace);
    if (!current) {
        windows[0]?.activate(global.get_current_time());
        return;
    }

    const centre = w => {
        const r = w.get_frame_rect();
        return [r.x + r.width / 2, r.y + r.height / 2];
    };
    const [cx, cy] = centre(current);

    let best = null;
    let bestScore = Infinity;
    for (const w of windows) {
        if (w === current)
            continue;
        const [x, y] = centre(w);
        const along = (x - cx) * dx + (y - cy) * dy;
        if (along <= 0)
            continue;
        const across = Math.abs((x - cx) * dy) + Math.abs((y - cy) * dx);
        const score = along + 2 * across;
        if (score < bestScore) {
            best = w;
            bestScore = score;
        }
    }
    best?.activate(global.get_current_time());
}

export default class DirectionalFocus extends Extension {
    enable() {
        this._actions = new Map();
        for (const [accel, [dx, dy]] of Object.entries(BINDINGS)) {
            const action = global.display.grab_accelerator(accel, Meta.KeyBindingFlags.NONE);
            if (action === Meta.KeyBindingAction.NONE) {
                console.warn(`directional-focus: ${accel} is already bound`);
                continue;
            }
            Main.wm.allowKeybinding(Meta.external_binding_name_for_action(action), Shell.ActionMode.NORMAL);
            this._actions.set(action, [dx, dy]);
        }
        this._handler = global.display.connect('accelerator-activated', (_display, action) => {
            const dir = this._actions.get(action);
            if (dir)
                focusNeighbour(...dir);
        });
    }

    disable() {
        global.display.disconnect(this._handler);
        for (const action of this._actions.keys())
            global.display.ungrab_accelerator(action);
        this._actions = null;
        this._handler = null;
    }
}
