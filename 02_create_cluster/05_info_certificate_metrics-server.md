# Additional information for running Kubernetes metrics-server

For those who don't want to allow `--kubelet-insecure-tls` as it is not a production recommended setup, follow the following steps:

1. On **each node** edit: `sudo vim /var/lib/kubelet/config.yaml` and add:

```yaml
serverTLSBootstrap: true
```

2. Confirm that `/var/lib/kubelet/config.yaml` contains this line (if not, add it):

```yaml
rotateCertificates: true
```

3. Restart kubelet: `sudo systemctl restart kubelet`

4. Kubelets will now send a Certificate Signing Request (CSR) to the API server, go to the **master node** and approve.

```bash
kubectl get csr   # check all pending
kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve
```

5. Wait for some time and verify if the metrics server was started and is ready.
