import Base
import ../arc/arc.bend as A
import ../lib/deploy.bend as D

# V's own architecture, written with Arc. V deploys by publishing its packages to the Bend hub
# (its only target); its source lives on GitHub. Nix, Homebrew and the Tailscale CLI are tools V
# drives only for projects that declare those targets.

# ---- where it runs ----
def nodes() -> List<&2, A.Node>:
  [ A.Node{"machine", "Mac mini", A.Server{}, A.Owned{"machine"}},
    A.Node{"outside", "Outside", A.Outside{}, A.Other{}} ]

def org() -> A.Org:
  A.Org{"Pedro", A.Vendor{"Apple", "iCloud"}, [A.PhysicalDevice{"machine", "Mac mini", "macOS"}]}

# ---- what it is ----
def near() -> List<&2, A.Container>:
  [ A.Container{"v", "v", A.Cli{}, A.Ours{}, "machine", A.Local{}, [], "", [], [], [], ["Bend 2", "C"]},
    A.Container{"bend", "Bend", A.Cli{}, A.Theirs{}, "machine", A.Local{}, [], "", [], [], [], ["Bend 2"]},
    A.Container{"nix", "Nix · nix-darwin", A.Cli{}, A.Theirs{}, "machine", A.Local{}, [], "", [], ["Nix", "nix-darwin"], [], []},
    A.Container{"brew", "Homebrew", A.Cli{}, A.Theirs{}, "machine", A.Local{}, [], "", ["Homebrew"], [], [], []},
    A.Container{"d2", "D2", A.Cli{}, A.Theirs{}, "machine", A.Local{}, [], "", ["D2"], [], [], []},
    A.Container{"tailscale", "Tailscale", A.Cli{}, A.Theirs{}, "machine", A.Local{}, [], "", ["Tailscale"], [], [], []},
    A.Container{"hub", "Bend hub", A.DataApi{}, A.Theirs{}, "outside", A.Public{}, [], "", ["Bend hub"], [], [], []},
    A.Container{"github", "GitHub", A.DataApi{}, A.Theirs{}, "outside", A.Public{}, [], "", ["GitHub"], [], [], []} ]

def parts() -> List<&2, A.Part>:
  [ A.Part{"cli", "v command (check, import, dryrun, plan, deploy, diagram)", A.Bend{}, "v", "machine"},
    A.Part{"arc", "Arc (near-architecture)", A.Bend{}, "v", "machine"},
    A.Part{"lib", "Deploy and Mac library", A.Bend{}, "v", "machine"},
    A.Part{"proc", "Run-a-program effect", A.C{}, "v", "machine"} ]

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
  A.System{org(), nodes(), near(), parts(), links()}

# ---- how V deploys: it publishes its packages to the Bend hub ----
def targets() -> List<&2, D.Target>:
  [D.BendHub{}]

def packages() -> List<&2, D.Package>:
  [ D.Package{"near-architecture", "0.8.0.0", "../arc/arc.bend"} ]
