# Linking `kubectl` on Host to a k3s Cluster in a Vagrant VM

This guide explains how to configure your **host machine's** `kubectl` to connect to a **k3s Kubernetes cluster** running inside a **Vagrant VM**.

---

## 1. Prerequisites

- **Vagrant VM** running k3s
- `kubectl` installed on your host machine
- SSH access to the VM (via `vagrant ssh`)

---

## 2. Retrieve the kubeconfig from the VM

By default, k3s stores its kubeconfig at:

```bash
/etc/rancher/k3s/k3s.yaml
```

SSH into the VM and copy the file to a location accessible from your host:

```bash
vagrant ssh
sudo cat /etc/rancher/k3s/k3s.yaml
```

Copy the content and save it as `k3s.yaml` on your host.

Alternatively, copy it directly from the host using `scp`:

```bash
vagrant ssh-config > ssh-config
scp -F ssh-config default:/etc/rancher/k3s/k3s.yaml ./k3s.yaml
```

---

## 3. Update the kubeconfig server address

Inside `k3s.yaml`, find the `server:` line, for example:

```yaml
server: https://127.0.0.1:6443
```

Change it to the VM's accessible IP address **or a custom domain**.  
You can use a domain like `k3s.local` instead of the IP for the server address.

You can find the VM's IP with:

```bash
vagrant ssh -c "ip addr show"
```

If you use a domain (e.g., `k3s.local`), add it to your host's `/etc/hosts` file pointing to the VM's IP:

```bash
echo "192.168.56.10 k3s.local" | sudo tee -a /etc/hosts
```

**Important:** The IP address or domain must be included in the k3s TLS certificate.

- If the IP or domain is not in the cert, reinstall k3s with:

  ```bash
  curl -sfL https://get.k3s.io | sh -s - server --tls-san <YOUR_IP_OR_DOMAIN>
  ```

- Replace `<YOUR_IP_OR_DOMAIN>` with your VM's private network IP or your chosen domain (e.g., `k3s.local`).

Example updated config:

```yaml
server: https://192.168.56.10:6443
```

or

```yaml
server: https://k3s.local:6443
```

---

## 4. (Optional) Allow insecure connection (dev only)

If you cannot or do not want to regenerate certs, you can bypass TLS verification:

```yaml
insecure-skip-tls-verify: true
```

And remove the `certificate-authority-data` line. **This is insecure — use only for local dev.**

---

## 5. Point `kubectl` to the config

You can either set the `KUBECONFIG` variable:

```bash
export KUBECONFIG=$(pwd)/k3s.yaml
kubectl get nodes
```

Or merge into your default kubeconfig:

```bash
mkdir -p ~/.kube
cp k3s.yaml ~/.kube/config
kubectl get nodes
```

---

## 6. Test the connection

Run:

```bash
kubectl get nodes
```

If configured correctly, you should see your k3s node(s) listed.

---

## 7. Troubleshooting

- **TLS errors**: Use the IP in the cert or reinstall with `--tls-san`.
- **Connection refused**: Check VM firewall and ensure port 6443 is open.
- **Timeouts**: Ensure the VM network is reachable from the host.

---

✅ You now have `kubectl` on your host linked to your k3s cluster in Vagrant!
