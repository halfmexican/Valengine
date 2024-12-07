namespace Valengine {
	namespace Audio {
		public class Sound : GLib.Object {
			/* Variables */
			private Raylib.Sound iSound;
			private bool isPaused = false;
			private float soundVolume = 1.0f;
			private float soundPitch = 1.0f;
			private float soundPan = 0.5f;
			/* Constructors */
			/**
			* Load sound from a file.
			*/
			public Sound(string file) {
				if(Raylib.is_audio_device_ready() == false) {
					Raylib.init_audio_device();
				}
				this.iSound = Raylib.load_sound(file);
			}
			/**
			* Load sound from memory
			*/
			public Sound.from_memory(uint8[] bytes, string fileType) {
				if(Raylib.is_audio_device_ready() == false) {
					Raylib.init_audio_device();
				}
				Raylib.Wave wave = Raylib.load_wave_from_memory(fileType, bytes);
				this.iSound = Raylib.load_sound_from_wave(wave);
				Raylib.unload_wave(wave);
			}
			/**
			* Create a new sound that shares the same sample data as the source sound, does not own the sound data
			*/
			public Sound.from_alias(Raylib.Sound source) {
				if(Raylib.is_audio_device_ready() == false) {
					Raylib.init_audio_device();
				}
				this.iSound = Raylib.load_sound_alias(source);
			}
			/**
			* Load sound from wave
			*/
			public Sound.from_wave(Raylib.Wave wave) {
				if(Raylib.is_audio_device_ready() == false) {
					Raylib.init_audio_device();
				}
				this.iSound = Raylib.load_sound_from_wave(wave);
			}
			/* Destroyer */
			~Sound() {
				Raylib.unload_sound(this.iSound);
			}
			/* Methods */
			/**
			* Update sound buffer with new data
			*/
			public void update(void* data, int sampleCount) {
				Raylib.update_sound(this.iSound, data, sampleCount);
			}
			/* Properties */
			/**
			* If sound is playing.
			*/
			public bool playing {
				get {
					return(Raylib.is_sound_playing(this.iSound));
				}
				set {
					if(value == true) {
						Raylib.play_sound(this.iSound);
						isPaused = false;
					} else {
						Raylib.stop_sound(this.iSound);
					}

				}
			}
			/**
			* If sound is paused
			*/
			public bool paused {
				get {
					return(this.isPaused);
				}
				set {
					if(value == true) {
						Raylib.pause_sound(this.iSound);
						isPaused = true;
					} else {
						Raylib.resume_sound(this.iSound);
						isPaused = false;
					}
				}
			}
			/**
			* Volume of sound.
			*/
			public float volume {
				get {
					return(this.soundVolume);
				}
				set {
					float volume = value;
					if(volume > 1.0f) {
						volume = 1.0f;
					} else if(volume < 0.0f) {
						volume = 0.0f;
					}
					Raylib.set_sound_volume(this.iSound, volume);
					this.soundVolume = volume;
				}
			}
			/**
			* Pitch of sound.
			*/
			public float pitch {
				get {
					return(this.soundPitch);
				}
				set {
					float pitch = value;
					if(pitch > 1.0f) {
						pitch = 1.0f;
					} else if(pitch < 0.0f) {
						pitch = 0.0f;
					}
					Raylib.set_sound_pitch(this.iSound, pitch);
					this.soundPitch = pitch;
				}
			}
			/**
			* Pan of sound.
			*/
			public float pan {
				get {
					return(this.soundPan);
				}
				set {
					float pan = value;
					if(pan > 1.0f) {
						pan = 1.0f;
					} else if(pan < 0.0f) {
						pan = 0.0f;
					}
					Raylib.set_sound_pan(this.iSound, pan);
					this.soundPan = pan;
				}
			}
		}
	}
}
