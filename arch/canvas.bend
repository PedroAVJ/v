import Base
import ../arc/arc.bend as A
import ../lib/deploy.bend as D

# V's own architecture, written with Arc. V deploys by publishing its packages to the Bend hub
# (its only target); its source lives on GitHub. Nix, Homebrew and Tailscale are used only for
# projects that declare those targets.

# ---- where it runs ----
def nodes() -> List<&2, A.Node>:
  [ A.Node{"machine", "Your machine", A.Server{}},
    A.Node{"outside", "Outside", A.Outside{}} ]

# ---- what it is ----
def near() -> List<&2, A.Container>:
  [ A.Container{"v", "v", A.Cli{}, A.Ours{}, "machine", A.Local{}, []},
    A.Container{"bend", "Bend", A.Cli{}, A.Theirs{}, "machine", A.Local{}, []},
    A.Container{"nix", "Nix · nix-darwin", A.Cli{}, A.Theirs{}, "machine", A.Local{}, []},
    A.Container{"brew", "Homebrew", A.Cli{}, A.Theirs{}, "machine", A.Local{}, []},
    A.Container{"d2", "D2", A.Cli{}, A.Theirs{}, "machine", A.Local{}, []},
    A.Container{"tailscale", "Tailscale", A.Network{}, A.Theirs{}, "machine", A.Tailnet{}, [A.PrivateAccess{}]},
    A.Container{"hub", "Bend hub", A.DataApi{}, A.Theirs{}, "outside", A.Public{}, []},
    A.Container{"github", "GitHub", A.DataApi{}, A.Theirs{}, "outside", A.Public{}, []} ]

def parts() -> List<&2, A.Part>:
  [ A.Part{"cli", "v command (check, import, dryrun, plan, deploy, diagram)", A.Bend{}, "v"},
    A.Part{"arc", "Arc (near-architecture)", A.Bend{}, "v"},
    A.Part{"lib", "Deploy and Mac library", A.Bend{}, "v"},
    A.Part{"proc", "Run-a-program effect", A.C{}, "v"} ]

def links() -> List<&2, A.Link>:
  [ A.Link{"cli", "bend", "compiles, proves, publishes", False{}},
    A.Link{"cli", "nix", "nix-darwin targets", False{}},
    A.Link{"cli", "brew", "nix-darwin targets", False{}},
    A.Link{"cli", "d2", "diagram", False{}},
    A.Link{"cli", "lib", "", False{}},
    A.Link{"lib", "arc", "", False{}},
    A.Link{"cli", "tailscale", "tailscale-serve targets", False{}},
    A.Link{"cli", "proc", "runs programs", False{}},
    A.Link{"arc", "hub", "bend-hub target (V's own)", False{}},
    A.Link{"v", "github", "source", False{}} ]

def system() -> A.System:
  A.System{nodes(), near(), parts(), links()}

# ---- how V deploys: it publishes its packages to the Bend hub ----
def targets() -> List<&2, D.Target>:
  [D.BendHub{}]

def packages() -> List<&2, D.Package>:
  [ D.Package{"near-architecture", "0.4.0.0", "../arc/arc.bend"} ]
