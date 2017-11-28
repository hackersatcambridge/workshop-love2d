# Installation Instructions

You can install LÖVE by downloading it from the [LÖVE homepage](https://love2d.org/) or by following the instructions below for this workshop.

## Windows

Download the [32 bit zip](https://bitbucket.org/rude/love/downloads/love-0.10.2-win32.zip), unzip it, and run `love.exe`.

You can also right-click on `love.exe` and create a shortcut for your desktop.

## Mac

Download [a zip containing LÖVE](https://bitbucket.org/rude/love/downloads/love-0.10.2-macosx-x64.zip), unzip it, move the `love.app` file to the desktop and `Ctrl + Click` the file to run LÖVE.

## Linux (Ubuntu 14.04 - 17.10)

You can download love from the PPA

```bash
sudo add-apt-repository ppa:bartbes/love-stable
sudo apt-get update
sudo apt-get install love
```

You will now be able to run LÖVE from the command line using `love`.

For other Linux/GNU systems, please refer to the [LÖVE homepage](https://love2d.org/).

## Results

Once you have followed your platform-specific instructions, you should see:

![Empty LÖVE project](images/love_startup.png)

# Creating a project

To create a LÖVE project, just create a folder with a single file in it called `main.lua`.

Drag this folder onto your LÖVE executable or run `love FOLDER_NAME` from the command line.

## Example main.lua

A `main.lua` will normally have a structure similar to what is below, however, the details of what we will put in these functions will be covered in the workshop.

```lua
function love.load()
    -- Do all your loading stuff here.
end

function love.update(dt)
    -- Do all your input and gameplay logic here.
end

function love.draw()
    -- Do all your graphics stuff here.
end
```

# Example Games

These are some example games created with LÖVE, just for this workshop.

- [CÖIN source](/zombie) `/zombie`

- [ZÖMBIE source](/coin): `/coin`

To run these, just drag the folders onto your LÖVE executable or run `love FOLDER_NAME` from the command line.
