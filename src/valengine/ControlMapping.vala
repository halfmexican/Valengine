using Valengine.Input;
using Gee;

namespace Valengine {
    public class ControlMapping {
        private HashMap<PlayerAction, Keyboard.Key> keyboard_bindings;
        private HashMap<PlayerAction, Gamepad.Button> gamepad_bindings;
        private HashMap<PlayerAction, Gamepad.Axis> gamepad_axis_bindings_left;
        private HashMap<PlayerAction, Gamepad.Axis> gamepad_axis_bindings_right;

        public ControlMapping () {
            keyboard_bindings = new HashMap<PlayerAction, Keyboard.Key>();
            gamepad_bindings = new HashMap<PlayerAction, Gamepad.Button>();
            gamepad_axis_bindings_left = new HashMap<PlayerAction, Gamepad.Axis>();
            gamepad_axis_bindings_right = new HashMap<PlayerAction, Gamepad.Axis>();

            // Default bindings
            keyboard_bindings[PlayerAction.MOVE_LEFT] = Keyboard.Key.LEFT;
            keyboard_bindings[PlayerAction.MOVE_RIGHT] = Keyboard.Key.RIGHT;
            keyboard_bindings[PlayerAction.MOVE_UP] = Keyboard.Key.UP;
            keyboard_bindings[PlayerAction.MOVE_DOWN] = Keyboard.Key.DOWN;
            keyboard_bindings[PlayerAction.JUMP] = Keyboard.Key.SPACE;


            gamepad_bindings[PlayerAction.MOVE_LEFT] = Gamepad.Button.LEFT_FACE_LEFT;
            gamepad_bindings[PlayerAction.MOVE_RIGHT] = Gamepad.Button.LEFT_FACE_RIGHT;
            gamepad_bindings[PlayerAction.MOVE_UP] = Gamepad.Button.RIGHT_FACE_UP;
            gamepad_bindings[PlayerAction.MOVE_DOWN] = Gamepad.Button.RIGHT_FACE_DOWN;
            gamepad_bindings[PlayerAction.JUMP] = Gamepad.Button.RIGHT_FACE_DOWN;


            // Axis bindings
            gamepad_axis_bindings_left[PlayerAction.MOVE_UP] = Gamepad.Axis.LEFT_Y;
            gamepad_axis_bindings_right[PlayerAction.MOVE_UP] = Gamepad.Axis.RIGHT_Y;
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

        public bool is_action_pressed (PlayerAction action, Gamepad ? gamepad) {
            if (Keyboard.is_pressed (keyboard_bindings[action])) {
                return true;
            }
            if (gamepad != null && gamepad.is_button_pressed (gamepad_bindings[action])) {
                return true;
            }
            return false;
        }

        public bool is_action_released (PlayerAction action, Gamepad ? gamepad) {
            if (Keyboard.is_released (keyboard_bindings[action])) {
                return true;
            }
            if (gamepad != null && gamepad.is_button_released (gamepad_bindings[action])) {
                return true;
            }
            return false;
        }

        public bool is_action_up (PlayerAction action, Gamepad ? gamepad) {
            if (Keyboard.is_up (keyboard_bindings[action])) {
                return true;
            }
            if (gamepad != null && gamepad.is_button_up (gamepad_bindings[action])) {
                return true;
            }
            return false;
        }

        public float get_axis_movement_left (PlayerAction action, Gamepad ? gamepad) {
            if (gamepad != null && gamepad_axis_bindings_left.contains (action)) {
                return gamepad.get_axis_movement (gamepad_axis_bindings_left[action]);
            }
            return 0.0f;
        }

        public float get_axis_movement_right (PlayerAction action, Gamepad ? gamepad) {
            if (gamepad != null && gamepad_axis_bindings_right.contains (action)) {
                return gamepad.get_axis_movement (gamepad_axis_bindings_right[action]);
            }
            return 0.0f;
        }
    }
}