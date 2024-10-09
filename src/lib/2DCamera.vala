using GLib;
using Valengine.Shapes;
using Valengine.Input;

namespace Valengine {
    public class 2DCamera : Object {
        public Raylib.Camera2D iCamera;

        /* Constructors */
        public 2DCamera (Vector2 offset, Vector2 target, float rotation, float zoom) {
            iCamera.offset = offset.iVector;
            iCamera.target = target.iVector;
            iCamera.rotation = rotation;
            iCamera.zoom = zoom;
        }

        // Named constructor
        public static 2DCamera.from_character_body (CharacterBody character, float rotation = 0.0f, float zoom = 1.0f) {
            Vector2 offset = new Vector2 (0, 0);
            Vector2 target = character.position;
            this(offset, target, rotation, zoom);
        }

        /* Methods */
        /**
         * Begin 2D mode with iCamera
         */
        public void begin_draw () {
            Raylib.begin_mode_2D (this.iCamera);
            return;
        }

        /**
         * Ends 2D mode with iCamera
         */
        public void end_draw () {
            Raylib.end_mode_2D ();
        }

        /**
         * Draw in 2D Mode.
         */
        public void draw (Func func) {
            this.begin_draw ();
            func (null);
            this.end_draw ();
        }

        /* Properties */
        /**
         * Offset of the iCamera
         */
        public Vector2 offset {
            owned get {
                return (new Vector2 (this.iCamera.offset.x, this.iCamera.offset.y));
            }
            set {
                this.iCamera.offset = value.iVector;
            }
        }
        /**
         * Target of the iCamera.
         */
        public Vector2 target {
            owned get {
                return (new Vector2 (this.iCamera.target.x, this.iCamera.target.y));
            }
            set {
                this.iCamera.target = value.iVector;
            }
        }
        /**
         * Zoom of the iCamera.
         */
        public float zoom {
            get {
                return (this.iCamera.zoom);
            }
            set {
                this.iCamera.zoom = value;
            }
        }
        /**
         * Rotation of the iCamera.
         */
        public float rotation {
            get {
                return (this.iCamera.rotation);
            }
            set {
                this.iCamera.rotation = value;
            }
        }

        public void update_camera_combined (CharacterBody target_body, float delta, int width, int height, float vertical_offset, CameraMode mode) {
            switch (mode) {
                case CameraMode.FOLLOW_PLAYER:
                    update_camera_center (target_body, delta, width, height, vertical_offset);
                    break;
                case CameraMode.FOLLOW_PLAYER_SMOOTH:
                    update_camera_center_smooth_follow (target_body, delta, width, height, vertical_offset);
                    break;
                case CameraMode.EVEN_OUT_ON_LANDING:                print ("Player crossed bottom boundary!\n");

                    update_camera_even_out_on_landing (target_body, delta, width, height, vertical_offset);
                    break;
                case CameraMode.PLAYER_BOUNDS_PUSH:
                    update_camera_target_body_bounds_push (target_body, delta, width, height, vertical_offset);
                    break;
            }
        }

        private void update_camera_center (CharacterBody target_body, float delta, int width, int height, float vertical_offset) {
            iCamera.offset = new Vector2 (width / 2.0f, height / 2.0f + vertical_offset).iVector;
            iCamera.target = target_body.position.iVector;
        }

        private void update_camera_center_smooth_follow (CharacterBody target_body, float delta, int width, int height, float vertical_offset) {
            iCamera.offset = new Vector2 (width / 2.0f, height / 2.0f + vertical_offset).iVector;
            Vector2 diff = new Vector2 (target_body.position.x - iCamera.target.x, target_body.position.y - iCamera.target.y);
            iCamera.target = new Vector2 (
                iCamera.target.x + diff.x * 0.1f,
                iCamera.target.y + diff.y * 0.1f
            ).iVector;
        }

        private void update_camera_target_body_bounds_push (CharacterBody target_body, float delta, int width, int height, float vertical_offset) {
            iCamera.offset = new Vector2 (width / 2.0f, height / 2.0f + vertical_offset).iVector;

            // Calculate iCamera bounds - the box in which the target_body can move freely without pushing the iCamera
            float bound_left = iCamera.target.x - width / 4.0f;
            float bound_right = iCamera.target.x + width / 4.0f;
            float bound_top = iCamera.target.y - height / 4.0f;
            float bound_bottom = iCamera.target.y + height / 4.0f;


            // Horizontal push
            if (target_body.position.x < bound_left) {
                // Create a new Vector2 to update the iCamera target
                iCamera.target = new Vector2 (target_body.position.x + width / 4.0f, iCamera.target.y).iVector;
            } else if (target_body.position.x > bound_right) {
                iCamera.target = new Vector2 (target_body.position.x - width / 4.0f, iCamera.target.y).iVector;
            }

            // Vertical push
            if (target_body.position.y < bound_top) {
                iCamera.target = new Vector2 (iCamera.target.x, target_body.position.y + height / 4.0f).iVector;
            } else if (target_body.position.y > bound_bottom) {
                iCamera.target = new Vector2 (iCamera.target.x, target_body.position.y - height / 4.0f).iVector;
            }
        }

        private void update_camera_even_out_on_landing (CharacterBody target_body, float delta, int width, int height, float vertical_offset) {
            const float MIN_SPEED = 50;
            const float MIN_EFFECT_LENGTH = 10;
            const float FRACTION_SPEED = 0.8f;
            const float EVEN_OUT_SPEED = 100.0f;

            /* Camera zoom controls */
            iCamera.zoom += ((float) Mouse.wheel_move.y * 0.05f);
            if (iCamera.zoom > 3.0f) {
                iCamera.zoom = 3.0f;
            } else if (iCamera.zoom < 0.1f) {
                iCamera.zoom = 0.1f;
            }

            /* Reset iCamera controls */
            if (Keyboard.is_down (Keyboard.Key.R)) {
                iCamera.zoom = 1.0f;
                iCamera.rotation = 0.0f;
            }

            iCamera.offset = new Vector2 (width / 2.0f, height / 2.0f + vertical_offset).iVector;
            Vector2 diff = new Vector2 (target_body.position.x - iCamera.target.x, target_body.position.y - iCamera.target.y);
            float length = (float) Math.sqrt (diff.x * diff.x + diff.y * diff.y);

            if (length > MIN_EFFECT_LENGTH) {
                float speed = (float) Math.fmax (FRACTION_SPEED * length, MIN_SPEED);
                iCamera.target = new Vector2 (
                    iCamera.target.x + diff.x * speed * delta / length,
                    iCamera.target.y + diff.y * speed * delta / length
                ).iVector;
            }

            if (target_body.can_jump) {
                if (iCamera.target.y < target_body.position.y) {
                    iCamera.target = new Vector2 (
                        iCamera.target.x,
                        iCamera.target.y + (float) Math.fmin (target_body.position.y - iCamera.target.y, EVEN_OUT_SPEED * delta)
                    ).iVector;
                } else if (iCamera.target.y > target_body.position.y) {
                    iCamera.target = new Vector2 (
                        iCamera.target.x,
                        iCamera.target.y - (float) Math.fmin (iCamera.target.y - target_body.position.y, EVEN_OUT_SPEED * delta)
                    ).iVector;
                }
            }
        }
    }
}
