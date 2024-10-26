---
layout:     post
title:      "Just an Ubuntu VM"
---

I often create vanilla Ubuntu virtual machines to reproduce bugs or practice
various sysadmin tasks. Doing this manually in virt-manager has gotten tedious.
Here is a fish function `uvtexec` that takes zero arguments. It creates a new VM
with its own SSH key, drops you into an SSH session, then destroys the VM once
you log out:

```shell
function uvtexec \
    --description='Create a new Ubuntu VM (from cloud image) and run script'

    # Get the short name (e.g. oracular) of the latest Ubuntu release
    set UBUNTU_LATEST (ubuntu-distro-info --latest)
    set ARCHITECTURE (dpkg --print-architecture)

    # Sync the latest Ubuntu cloud images
    uvt-simplestreams-libvirt --verbose sync \
        release=$UBUNTU_LATEST \
        arch=$ARCHITECTURE \
        label=daily

    # Make sure we actually have a matching image
    uvt-simplestreams-libvirt query \
        release=$UBUNTU_LATEST \
        arch=$ARCHITECTURE \
        label=daily \
    || return 2

    # Create a VM:
    # Initialize name as some UUID
    set TMP_VM_NAME (python3 -c "import uuid; print(uuid.uuid4())")

    # Create an SSH key for this VM
    set TMP_VM_KEYPATH "$HOME/.ssh/id_ed25519_$TMP_VM_NAME"
    ssh-keygen \
        -q \
        -t ed25519 \
        -N '' \
        -C "Created automatically on $(date -Iseconds)" \
        -f $TMP_VM_KEYPATH

    # Create VM. Set memory to 2048 MiB as default 512 is too small
    uvt-kvm create \
        $TMP_VM_NAME \
        release=$UBUNTU_LATEST \
        arch=$ARCHITECTURE \
        label=daily \
        --memory=2048 \
        --ssh-public-key-file=$TMP_VM_KEYPATH.pub
    uvt-kvm wait \
        $TMP_VM_NAME \
        --ssh-private-key-file=$TMP_VM_KEYPATH

    # SSH into the machine. The `uvt-kvm ssh` command doesn't let us specify
    # the keyfile, so we have to do this the long way:
    set TMP_VM_IP (uvt-kvm ip $TMP_VM_NAME)
    if test (count $argv) -lt 1
        # SSH into the machine and play around
        ssh -i $TMP_VM_KEYPATH ubuntu@$TMP_VM_IP
    else
        # TODO: Do something interesting if additional arguments provided
    end

    # Clean up
    uvt-kvm destroy $TMP_VM_NAME
    rm -v $TMP_VM_KEYPATH "$TMP_VM_KEYPATH.pub"
end
```

Save this as `~/.config/fish/functions/uvtexec.fish`. It only works in Ubuntu
and requires `uvtools` and `ssh`.
