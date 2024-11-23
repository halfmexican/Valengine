using Valengine.Input;
using Gee;
namespace Valengine {
    public class ControlMapping {
        private HashMap<PlayerAction, Keyboard.Key> keyboard_bindings;
        private HashMap<PlayerAction, Gamepad.Button> gamepad_bindings;

        // TODO: Add methods to add/remove bindings
        // TODO: Rewrite Demos to use this class
        public ControlMapping () {
            keyboard_bindings = new HashMap<PlayerAction, Keyboard.Key>();
            gamepad_bindings = new HashMap<PlayerAction, Gamepad.Button>();

            // Default bindings
            keyboard_bindings[PlayerAction.MOVE_LEFT] = Keyboard.Key.LEFT;
            keyboard_bindings[PlayerAction.MOVE_RIGHT] = Keyboard.Key.RIGHT;
            keyboard_bindings[PlayerAction.JUMP] = Keyboard.Key.SPACE;

            gamepad_bindings[PlayerAction.MOVE_LEFT] = Gamepad.Button.LEFT_FACE_LEFT;
            gamepad_bindings[PlayerAction.MOVE_RIGHT] = Gamepad.Button.LEFT_FACE_RIGHT;
            gamepad_bindings[PlayerAction.JUMP] = Gamepad.Button.RIGHT_FACE_DOWN;
        }

        public bool is_action_down (PlayerAction action, Gamepad ? gamepad) {
            if (Keyboard.is_down (keyboard_bindings[action])) {
                return true;
            }
            if (gamepad != null && gamepad.is_button_down (gamepad_bindings[action])) {
                return true;
            }
            return false;
        }
    }
}