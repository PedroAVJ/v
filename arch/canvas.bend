import Base
import near-architecture@0.2.0.0/arc.bend as A

# V's own architecture, written with Arc. V runs on the machine it manages; it deploys by
# publishing packages to the Bend hub, and its source lives on GitHub.

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
  [ A.Link{"cli", "bend", "compiles and proves the project", False{}},
    A.Link{"cli", "nix", "darwin-rebuild · nix build", False{}},
    A.Link{"cli", "brew", "bundle", False{}},
    A.Link{"cli", "d2", "diagram", False{}},
    A.Link{"cli", "lib", "", False{}},
    A.Link{"lib", "arc", "", False{}},
    A.Link{"cli", "tailscale", "serve", False{}},
    A.Link{"cli", "proc", "runs programs", False{}},
    A.Link{"arc", "hub", "publish", False{}},
    A.Link{"v", "github", "source", False{}} ]

def system() -> A.System:
  A.System{nodes(), near(), parts(), links()}

# ---- what V publishes to the hub ----
type Package is Data:
  Package{name: String, version: String, files: List<&2, String>}

def packages() -> List<&2, Package>:
  [ Package{"near-architecture", "0.2.0.0", ["arc/arc.bend", "arc/LICENSE"]} ]

# The hub's rule: a name is 12 to 64 characters of a-z, 0-9 and -.
def name_ok(+n: String) -> Bool:
  Nat.is_ge(String.length(n), 12n) && Nat.is_le(String.length(n), 64n)

def ends_license(+f: String) -> Bool:
  String.ends_with(f, "/LICENSE") || String.eq(f, "LICENSE")

def any_license(fs: List<&2, String>) -> Bool:
  match fs:
    case []:
      False{}
    case f <> rest:
      ends_license(f) || any_license(rest)

# Every package has a valid hub name and ships a LICENSE.
def packages_ok(xs: List<&2, Package>) -> Bool:
  match xs:
    case []:
      True{}
    case p <> rest:
      match p:
        case Package{n, _, fs}:
          name_ok(n) && any_license(fs) && packages_ok(rest)
