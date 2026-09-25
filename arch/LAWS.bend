import Base
import near-architecture@0.2.0.0/arc.bend as Arc
import ./canvas.bend as V

# V is well formed, and what runs on the machine is reachable only from it or the private network.
law well_formed:
  {Arc.well_formed(V.system()) == True{} : Bool}
law machine_private:
  {Arc.servers_private(V.system()) == True{} : Bool}

# Every package V publishes has a valid hub name and ships a LICENSE.
law packages_ok:
  {V.packages_ok(V.packages()) == True{} : Bool}
