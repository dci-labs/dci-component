# dci-component

GitHub Action to create a [DCI]() [component]() in multiple [topics]().

## Usage

### Pre-requisites

In order to use this Action, a [RemoteCI](https://docs.distributed-ci.io/#remote-ci) is required. Follow these steps to create one if one is not already created.

- Login into your account: [https://www.distributed-ci.io/login](https://www.distributed-ci.io/login)
- Go to the RemoteCI section: [https://www.distributed-ci.io/remotecis](https://www.distributed-ci.io/remotecis)
- Click on "Create a new remoteci" button
  - Set a name
  - Select team owner
- Search your newly created RemoteCI
  - Click on the Authenticate "blue incognito button"
  - Copy on the button "Copy to clipboard"
- Save the content in a file

### GitHub Secrets

With the RemoteCI data create two secrets, any name can be used for the secrets, we will use the same for consistency:

- `DCI_CLIENT_ID`: Use the content of `DCI_CLIENT_ID`, e.g. `remoteci/012345678-90ab-...`
- `DCI_API_SECRET`: Use the content of `DCI_API_SECRET`, e.g. `abcxyzABCXYZ01239...`

### Inputs

Some Inputs are required, while others are optional.

**Required**:

- `dciClientId`: Remote CI client ID, this is passed as a secret.
- `dciApiSecret`: Remote CI API secret, this is passed as a secret.
- `dciTopics`: A comma separated list of DCI topics example:

    ```yaml
    # Single topic
    dciTopics: OCP-4.12

    # Multiple topics
    dciTopics: 'OCP-4.11,OCP-4.12'
    
    # Multiple topics, multi-line
    dciTopics: '
    OCP-4.10,
    OCP-4.11,
    OCP-4.12,
    '

    # Other topics
    dciTopics: RHEL-9.2
    ```

- `componentName`: DCI component name, e.g. `My Awesome Component` or `FredCo awesome operator` or `acme-component`, etc.
- `componentVersion`: DCI component version, the version of the component to create, e.g. `v1.2.3`, `22.10`, `9.2-rc1`, `v12.28.12-alpha`, etc.
- `componentRelease`: DCI component release tag, must be one of the following: `dev`, `candidate` or `ga`.

**Optional**:

- `dciCsUrl`: Remote CI control server URL, default is `https://api.distributed-ci.io/`.
- `componentTags`: List of DCI component Tags, for example:

    ```yaml
    # Single Tag
    componentTags: "arch:arm64"

    # Multiple Tags
    dciTags: "os:linux,arch:amd64"
    ```

- `componentUrl`: DCI component URL, requires an http(s) schema, e.g. `https://my-site.com`, `https://github.com/my-org/my-repo`
- `componentData`: DCI component data, a compact (one-liner) json entry, e.g. `{"foo": "bar"}`, `{"uno":null,"dos":["tres",{"sub":{"on":true,"off":false}}]}`

### Workflow

Here few examples on how to use this Action in your workflow as a step

Creating component `My container application` with version `v1.2.3-alpha`, and `dev` release. The component will be created only in `OCP-4.12`.

```YAML
    steps:
      - name: Create DCI components
        uses: dci-labs/dci-component@v1.0.0
        with:
          dciClientId: ${{ secrets.DCI_CLIENT_ID }}
          dciApiSecret: ${{ secrets.DCI_API_SECRET }}
          dciTopics:
            - "OCP-4.12"
          componentName: "My container application"
          componentVersion: v1.2.3
          componentRelease: "dev"
```

Creating a component on multiple OCP topic versions with name `my-operator` and version `22.04`, with a reference to its repository `https://github.com/myorg/my-operator`, with some custom tags, and the location of the image: `{"imageURL": "quay.io/myorg/my-operator:22.04"}`

```YAML
    steps:
      - name: Create DCI components
        uses: dci-labs/dci-component@v1.0.0
        with:
          dciClientId: ${{ secrets.DCI_CLIENT_ID }}
          dciApiSecret: ${{ secrets.DCI_API_SECRET }}
          dciTopics: '
          OCP-4.8,
          OCP-4.9,
          OCP-4.10,
          OCP-4.11
          '
          componentName: my-operator
          componentVersion: "22.04"
          componentRelease: ga
          componentUrl: https://github.com/myorg/my-operator
          componentTags: "ansible-operator,os:linux,2022"
          componentData: {"imageURL": "quay.io/myorg/my-operator:22.04"}
```

The output of the component created is stored in `components` and can be re-used like this:

```YAML
    steps:
      - name: Create DCI components
        uses: dci-labs/dci-component@v1.0.0
        with:
          dciClientId: ${{ secrets.DCI_CLIENT_ID }}
          dciApiSecret: ${{ secrets.DCI_API_SECRET }}
          dciTopics:
            - "OCP-4.12"
          componentName: "My container application"
          componentVersion: v1.2.3
          componentRelease: "dev"
        id: my_cmp

      - run: jq . <<<"${{ steps.my_cmp.outputs.components }}"
```
