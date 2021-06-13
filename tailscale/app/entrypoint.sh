# Initially from https://www.kadenbarlow.dev/blog/tailscale/
set -m # enables job control to use fg command
kubectl create configmap $TAILSCALE_CONFIG_MAP # create the config map to backup tailscale data if it doesn't exist

sysctl -w net.ipv4.ip_forward=1

tailscaled >/dev/null 2>&1 & # start the tailscale daemon
sleep 10 # allows for the service to boot an connect before trying to register container with tailscale
tailscale up -hostname $TAILSCALE_HOSTNAME -authkey $TAILSCALE_AUTH_KEY -advertise-routes $TAILSCALE_ADVERTISE_ROUTES # connect to VPN

data=$(cat /var/lib/tailscale/tailscaled.state | sed 's/\"/\\\"/g' | sed ':a;N;$!ba;s/\n/ /g') # backup updated tailscale data to configmap
kubectl patch configmap $TAILSCALE_CONFIG_MAP -p "{\"data\": {\"state\": \"$data\"}}"

fg # bring the tailscaled process to foreground
