# Valengine executable
if get_option('valengine') == true
    executable(
        'valengine',
        dependencies: [valengine_dep],
        sources: [
            'vengine_oop.vala',
            'CharacterBody.vala',
            'PlayerBody.vala',
            'meta/license.vala',
            'meta/version.vala',
        ],
        install: true,
    )
endif
