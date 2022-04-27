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
- `dciTopicVersion`: DCI topic version, e.g. `4.10` or `4.11,4.10,4.9` or `all`.
- `componentName`: DCI component name, this is usually the **version** of your component, e.g. `v1.2.3` or `22.04` or `0.1-alpha`.
- `componentCanonicalName`: DCI component canonical name, this is usually the **name** of your component, e.g. `my operator`, `my-app`.
- `componentType`: DCI component type, the type of component to create, e.g. `operator`, `cnf-app`, `git-repo`, `rpm`, `container-image`

**Optional**:

- `dciCsUrl`: Remote CI control server URL, (default: `https://api.distributed-ci.io/`)
- `dciTopic`: DCI topic, the only supported so far is `OCP` (default: `OCP`)
- `componentUrl`: DCI component URL, requires an http(s) schema, e.g. `https://my-site.com`, `https://github.com/my-org/my-repo`
- `componentData`: DCI component data, a compact (one-liner) json entry, e.g. `{"foo": "bar"}`, `{"uno":null,"dos":["tres",{"sub":{"on":true,"off":false}}]}`

### Workflow

Here few examples on how to use this Action in your workflow as a step

Creating a component on the OCP topic under its version `4.10` with name `v1.2.3` and its canonical name `My container application` of type `image`.

```YAML
    steps:
      - name: Create DCI components
        uses: tonyskapunk/dci-component@v0.1.0
        with:
          dciClientId: ${{ secrets.DCI_CLIENT_ID }}
          dciApiSecret: ${{ secrets.DCI_API_SECRET }}
          dciTopicVersion: "4.10"
          componentName: v1.2.3
          componentCanonicalName: "My container application"
          componentType: image

```

Creating a component on `all` the OCP topic versions with name `22.04` and its canonical name `my-operator` of type `operator`, with a reference to its repository `https://github.com/myorg/my-operator` and another reference to the image under: `{"imageURL": "quay.io/myorg/my-operator:22.04"}`

```YAML
    steps:
      - name: Create DCI components
        uses: tonyskapunk/dci-component@v0.2.0
        with:
          dciClientId: ${{ secrets.DCI_CLIENT_ID }}
          dciApiSecret: ${{ secrets.DCI_API_SECRET }}
          dciTopicVersion: all
          componentName: 22.04
          componentCanonicalName: my-operator
          componentType: operator
          componentUrl: https://github.com/myorg/my-operator
          componentData: {"imageURL": "quay.io/myorg/my-operator:22.04"}
```
