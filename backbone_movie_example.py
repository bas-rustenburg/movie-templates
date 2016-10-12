from jinja2 import Template
with open("template scripts/backbone-inspector-template.pml", 'r') as template_file:
    template = Template(template_file.read())

settings = {
 "movie_fps" : 45, # the frames per second
 "structure_pdb" : "4lzt", # PDB code, incompatible with structure_file
 "relative_lag": 2, # integer, set higher for slower movie
 "backbone_only" : False, # Set to True to only display backbone
 "representation": "lines", # Display mode for all atoms
 "background_color": "white", # color for the background
 "carbon_color": "gray20", # color for all carbon atoms
 "first_residue": 1, # First residue in the segment
 "last_residue": 12, # Last residue of the segment
 "ray_trace_frames": False, # Set ray trace on or off
 "ray_shadow": False, # Set ray shadows on or off
}

with open("moviescript.pml", 'w') as outputfile:
    outputfile.write(template.render(**settings))
