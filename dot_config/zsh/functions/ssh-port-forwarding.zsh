fip() {
  (( $# >= 2 )) || { print -u2 'Usage: fip <host> <port1> [port2] ...'; return 1; }
  local host=$1 port
  shift
  for port in "$@"; do
    command ssh -f -N -L "${port}:localhost:${port}" "$host" && print "Forwarding localhost:$port -> $host:$port"
  done
}

dip() {
  (( $# )) || { print -u2 'Usage: dip <port1> [port2] ...'; return 1; }
  local port
  for port in "$@"; do
    pkill -f "ssh.*-L ${port}:localhost:${port}" && print "Stopped forwarding port $port" || print "No forwarding on port $port"
  done
}

lip() {
  pgrep -af 'ssh.*-L [0-9]+:localhost:[0-9]+' || print 'No active forwards'
}
