using GLib;
using Valengine.Shapes;

namespace Valengine {
    public class 2DCamera : Object {
        internal Raylib.Camera2D iCamera;
        /* Constructors */
        public 2DCamera (Vector2 offset, Vector2 target, float rotation, float zoom) {
            iCamera.offset = offset.iVector;
            iCamera.target = target.iVector;
            iCamera.rotation = rotation;
            iCamera.zoom = zoom;
        }
        /* Methods */
        /**
         * Begin 2D mode with camera
         */
        public void begin_draw () {
            Raylib.begin_mode_2D (this.iCamera);
            return;
        }

        /**
         * Ends 2D mode with camera
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
         * Offset of the camera
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
         * Target of the camera.
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
         * Zoom of the camera.
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
         * Rotation of the camera.
         */
        public float rotation {
            get {
                return (this.iCamera.rotation);
            }
            set {
                this.iCamera.rotation = value;
            }
        }
    }
}
