import Base
import ../lib/effs/io.bend as X
import ../lib/vstr.bend as S

# The project `v` runs in: the current folder. Its own Bend programs (facts, plan, flake, laws...)
# are compiled and run from there.

# Compile one of the project's Bend programs to a native binary, then run it; answers its output.
def run_bend(+file: String) -> IO(String):
  X.sh("$HOME/.bend/bin/bend " ++ file ++ " -o /tmp/v-" ++ file ++ ".bin >/dev/null 2>&1 && /tmp/v-" ++ file ++ ".bin")

# Type-check a Bend file (the laws); nothing is run.
def check_bend(file: String) -> IO(String):
  X.sh("$HOME/.bend/bin/bend " ++ file ++ " 2>&1 || true")

# ---- the project's facts (facts.bend): its flake host, where V's library is, its services' labels and ports ----
type Facts is Data:
  Facts{host: String, vlib: String, labels: List<&2, String>, ports: List<&2, String>}

def fact_values(+k: String, ls: List<&2, String>) -> List<&2, String>:
  match ls:
    case []:
      []
    case +l <> rest:
      S.append(S.line_if(String.starts_with(l, k ++ " "), String.drop(l, Nat.add(String.length(k), 1n))), fact_values(k, rest))

def read_facts() -> IO(Facts):
  do IO<Facts>:
    out : String <- run_bend("facts.bend")
    +ls : List<&2, String> = String.lines(out)
    return Facts{S.nth(fact_values("host", ls), 0n), S.nth(fact_values("vlib", ls), 0n), fact_values("label", ls), fact_values("port", ls)}

def flake_host(f: Facts) -> String:
  match f:
    case Facts{h, _, _, _}:
      h

def vlib_of(f: Facts) -> String:
  match f:
    case Facts{_, v, _, _}:
      v

def labels_of(f: Facts) -> List<&2, String>:
  match f:
    case Facts{_, _, l, _}:
      l

def ports_of(f: Facts) -> List<&2, String>:
  match f:
    case Facts{_, _, _, p}:
      p

