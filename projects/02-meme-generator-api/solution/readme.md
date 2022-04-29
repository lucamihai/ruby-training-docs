# Meme Generator API

## Setup

* You'll need to install [GraphicsMagick](http://www.graphicsmagick.org/), then restart your computer.
* You'll also need to install [SQLite3](https://www.sqlite.org/index.html) (version 3.6.16 or newer) on your computer.

## Starting the server

Run the following command in a terminal.
```
rackup
```

You could also specify a port by providing it as an argument
```
rackup -p <port>
```

## Usage

Perform HTTP requests to the following endpoints:

### Generate meme
POST <server_url>/memes
```
{
    "original_image_path": "images\\meme_templates\\senator_armstrong.jpg",
    "final_image_path": "images\\memes\\the_mother_of_all_omelettes.jpg",
    "captions": [
        {
            "text": "Making the mother of all omelettes here Jack.",
            "font": "Arial",
            "fill_color": "White",
            "under_color": "Black",
            "point_size": 55,
            "position_x": 0,
            "position_y": -300
        },
        {
            "text": "Cant fret over every egg.",
            "font": "Arial",
            "fill_color": "White",
            "under_color": "Black",
            "point_size": 55,
            "position_x": 0,
            "position_y": 300
        }
    ]
}
```
**Notice** : please don't include texts containg the ``[']`` character. I was too lazy to escape it.

Redirects to an image of the generated meme.
