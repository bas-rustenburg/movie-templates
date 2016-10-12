{# Template for backbone inspection movie, supports these options
settings = {
 "movie_fps" : 45, # the frames per second
 "structure_pdb" : "4lzt", # PDB code, incompatible with structure_file
 "relative_lag": 1, # integer, set higher for slower movie
 "structure_file" : "/home/bas/files/protein.pdb", # local file, incompatible with structure_pdb
 "backbone_only" : False, # Set to True to only display backbone
 "representation": "lines", # Display mode for all atoms
 "background_color": "white", # color for the background
 "carbon_color": "gray20", # color for all carbon atoms
 "first_residue": 1, # First residue in the segment
 "last_residue": 12, # Last residue of the segment
 "ray_trace_frames": False, # Set ray trace on or off
 "ray_shadow": False, # Set ray shadows on or off
}
#}

# Start of script
# Please run this using the run command in pymol.

reinitialize
set matrix_mode, 1
set movie_panel, 1
set movie_fps, {{ movie_fps }}
{% if ray_trace_frames %}
set ray_trace_frames, on
{# Disable shadows by default #}
  {% if ray_shadow %}
  set ray_shadow, on
  {% else %}
  set ray_shadow, off
  {% endif %}
{% endif %}

{# Calculate total residues #}
{% set total_residues=(last_residue - first_residue + 1)  %}

# Load the structure
{% if structure_file is defined %}
# From this local file
load {{ structure_file }}
{% elif structure_pdb is defined %}
# From the protein databank
fetch {{ structure_pdb }}, async=0
{% endif %}

# The representation
{% if backbone_only %}
# Representing the backbone
as {{ representation }}, n. C+O+N+CA
{% else %}
# Representing the entire system
as {{ representation }}
{% endif %}
bg_color {{ background_color }}
color {{carbon_color}}, elem c
# Zoom in on first two residues
zoom i. {{ first_residue }}+{{ first_residue + 1}}

# Total frames
{# 20 frames per AA is the default, lag time increases it #}
mset 1 x{{ 20 * total_residues * relative_lag }}
mview store

# Label c-alphas
label n. CA, "%s-%s" % (resn, resi)

# this code maps the zooming of
# one AA and it's neighbor to 10 frames
python
for x in range({{ first_residue - 1 }},{{ last_residue }}):
  cmd.frame(({{ relative_lag }}*20*x)+1)
  {% if backbone_only %}

  # Backbone zoom
  cmd.zoom( "n. CA and i. " + str(x) + "+" + str(x+1))
  {% else %}

  # Residue zoom
  cmd.orient( "i. " + str(x) + "+" + str(x+1))
  {% endif %}

  cmd.mview("store")
python end

# Go to the last frame, store, and interpolate the frames
frame {{ 2 * total_residues }}
mview store
mview reinterpolate

# Play the movie
mplay
