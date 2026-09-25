# V

Describe a system once, as types, and derive everything else from it.
A broken invariant is a compile error, never a runtime surprise.

V is a framework, not a language: the language is [Bend 2](https://bend-lang.com).
It builds on packages from the Bend hub, and nothing in it is specific to one project.

## Arc

`arc/arc.bend` is the architecture layer, published on its own. A system is two
hierarchies over the same containers:

- **Where it runs:** node → container → part. Nodes are yours to declare, each with a
  role: `UserDevice`, `Server`, `Overlay` (the private network) or `Outside`.
- **What it is:** system → container → part. A container is one of a closed list of
  kinds (`Client`, `Network`, `DataApi`, `AgentApi`, `ModelApi`, `Worker`), `Ours` or
  `Theirs`, with an exposure (`Local`, `Lan`, `Tailnet`, `Device`, `Public`) and the
  capabilities it provides.

Keys work like foreign keys, and a project writes its laws with Arc's predicates:
well-formedness, private servers, devices reaching servers only through the private
network, each capability provided exactly once, and a D2 diagram.

## The rest of V

- `lib/deploy.bend`: services, routes and launchd jobs for an Arc system; what a change
  breaks; minimality against the machine (launch agents, listeners); the deploy plan and
  the nix-darwin flake.
- `lib/mac.types.bend`: a Mac's nix-darwin-labeled settings, declared and observed, and
  the typed firewall.
- `cli/`: the `v` command. The only foreign code is one C effect (`lib/effs/proc_run.c`)
  that runs another program.

Packages: `bend-net-json@0.3.0.0` (Tailscale's serve status), `bend-net-url@0.4.0.0` (URL decoding).

## A project

`v` runs in a project's folder. The project describes itself with Arc and V's library and
provides small programs `v` compiles and runs: `facts.bend` (its flake host, where V's
library is, its services), `plan.bend`, `current.bend`, `flake.bend`, `diagram.bend`,
`mac.gen.bend`, `mac.dryrun.bend`, and its laws (`LAWS.bend` / `PROOF.bend`).

```sh
bend cli/main.bend -o bin/v     # build v
v check      # snapshot the machine, then prove the project's laws
v import     # read the Mac into mac.now.bend (mac.bend keeps its declarations)
v dryrun     # what applying mac.bend would change, without changing anything
v plan       # the deploy steps
v deploy     # prove, then apply with nix-darwin and Tailscale Serve
v diagram out.png
```

## License

MIT.
