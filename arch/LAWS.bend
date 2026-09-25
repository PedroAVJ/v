import Base
import near-architecture@0.2.0.0/arc.bend as Arc
import ../lib/deploy.bend as D
import ./canvas.bend as V

# V is well formed, and what runs on the machine is reachable only from it or the private network.
law well_formed:
  {Arc.well_formed(V.system()) == True{} : Bool}
law machine_private:
  {Arc.servers_private(V.system()) == True{} : Bool}

# Every package V publishes follows the hub's rules (name and version); `v deploy` also requires its LICENSE.
law packages_ok:
  {D.packages_ok(V.packages()) == True{} : Bool}
