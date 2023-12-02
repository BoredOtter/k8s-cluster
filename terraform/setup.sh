gcloud compute networks create k8s-cluster-network --subnet-mode custom
gcloud compute networks subnets create k8s-subnet \
  --network k8s-cluster-network \
  --range 10.240.0.0/24 \
  --region europe-west4

# Create firewall rules for internal and external traffic
gcloud compute firewall-rules create k8s-subnet-allow-internal \
  --allow tcp,udp,icmp \
  --network k8s-cluster-network \
  --source-ranges 10.240.0.0/24

gcloud compute firewall-rules create k8s-subnet-allow-external \
  --allow tcp:80,tcp:6443,tcp:443,tcp:22,icmp \
  --network k8s-cluster-network \
  --source-ranges 0.0.0.0/0

# Create a static IP
gcloud compute addresses create k8s-master-0-public-ip --project=cedar-bot-406923 --region=europe-central2

# Get the created static IP
IP_ADDRESS=$(gcloud compute addresses describe k8s-master-0-public-ip --region=europe-central2 --format='get(address)')

# Create controller instance with the static IP
gcloud compute instances create master-0 \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-2204-lts \
    --image-project ubuntu-os-cloud \
    --machine-type e2-standard-2 \
    --private-network-ip 10.240.0.10 \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet k8s-subnet \
    --tags k8s-instance,worker \
    --zone europe-central2-a \
    --address $IP_ADDRESS


# Create worker instances
for i in 0 1; do
  # Create a static IP
  gcloud compute addresses create worker-${i}-public-ip --project=cedar-bot-406923 --region=europe-central2

  # Get the created static IP
  IP_ADDRESS=$(gcloud compute addresses describe worker-${i}-public-ip --region=europe-central2 --format='get(address)')

  gcloud compute instances create worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-2204-lts \
    --image-project ubuntu-os-cloud \
    --machine-type e2-standard-2 \
    --private-network-ip 10.240.0.2${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet k8s-subnet \
    --tags k8s-instance,worker \
    --zone europe-central2-a \
    --address $IP_ADDRESS
done

# List instances with specified tags
gcloud compute instances list --filter="k8s-instance"