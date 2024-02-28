# dci-component

[![License](https://img.shields.io/github/license/dci-labs/dci-component)](https://github.com/dci-labs/dci-component/blob/main/LICENSE)
[![Major Release)](https://img.shields.io/github/v/release/dci-labs/dci-component?label=major)](https://github.com/dci-labs/dci-component/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/dci-labs/dci-component?label=latest)](https://github.com/dci-labs/dci-component/tags)

GitHub Action to create a [DCI](https://docs.distributed-ci.io/) [component](https://docs.distributed-ci.io/#component) in multiple [topics](https://docs.distributed-ci.io/#topic).

When a component already exists, the component will be retrieved, it will not update it.

## Usage

### Pre-requisites

To use this Action, a [RemoteCI](https://docs.distributed-ci.io/#remote-ci) is required. Follow these steps to create one if one is not already created.

- Login into your account: [https://www.distributed-ci.io/login](https://www.distributed-ci.io/login)
- Go to the RemoteCI section: [https://www.distributed-ci.io/remotecis](https://www.distributed-ci.io/remotecis)
- Click on the "Create a new remoteci" button
  - Set a name
  - Select team owner
- Search your newly created RemoteCI
  - Under the Authentication column click on credentials.yaml
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
- `dciTopics`: A comma-separated list of DCI topics, or a special term `all-<TOPIC_TYPE>`for the latest (last 6) topics. Where `TOPIC_TYPE`is one of: `OCP`, `OSP` or `RHEL`.

    ```yaml
    # Single topic
    dciTopics: OCP-4.12

    # Multiple topics
    dciTopics: 'OCP-4.11,OCP-4.12'
    
    # Multiple topics, multi-line
    dciTopics: '
    OCP-4.11,
    OCP-4.12,
    OCP-4.13,
    '

    # Other topics
    dciTopics: RHEL-9.2

    # All the latest versions of the OSP topic
    dciTopics: all-osp

    # All the latest versions of the OCP topic
    dciTopics: all-OCP
    ```

- `componentName`: DCI component name, e.g. `My Awesome Component` or `FredCo awesome operator` or `acme-component`, etc.
- `componentVersion`: DCI component version, the version of the component to create, e.g. `v1.2.3`, `22.10`, `9.2-rc1`, `v12.28.12-alpha`, etc.
- `componentRelease`: DCI component release tag must be one of the following: `dev`, `candidate` or `ga`.

**Optional**:

- `dciCsUrl`: Remote CI control server URL, default is `https://api.distributed-ci.io/`.
- `componentTags`: List of DCI component Tags, for example:

    ```yaml
    # Single Tag
    componentTags: "arch:arm64"

    # Multiple Tags
    componentTags: "os:linux,arch:amd64"
    ```

- `componentUrl`: DCI component URL, requires an http(s) schema, e.g. `https://my-site.com`, `https://github.com/my-org/my-repo`
- `componentData`: DCI component data, a compact (one-liner) JSON entry, e.g. `{"foo": "bar"}`, `{"uno":null,"dos":["tres",{"sub":{"on":true,"off":false}}]}`

### Workflow

Here few examples of how to use this Action in your workflow as a step

Creating component `My container application` with version `v1.2.3-alpha`, and `dev` release. The component will be created only in `OCP-4.12`.

```YAML
    steps:
      - name: Create DCI components
        uses: dci-labs/dci-component@v1.0.0
        with:
          dciClientId: ${{ secrets.DCI_CLIENT_ID }}
          dciApiSecret: ${{ secrets.DCI_API_SECRET }}
          dciTopics: "OCP-4.12"
          componentName: "My container application"
          componentVersion: v1.2.3
          componentRelease: "dev"
```

Creating a component on multiple OCP topic versions with the name `my-operator` and version `22.04`, with a reference to its repository `https://github.com/myorg/my-operator`, with some custom tags, and the location of the image: `{"imageURL": "quay.io/myorg/my-operator:22.04"}`

```YAML
    steps:
      - name: Create DCI components
        uses: dci-labs/dci-component@v1
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

The output of the component created is stored in `components` and can be re-used like this for a nice output in GHA:

```YAML
    steps:
      - name: Create DCI components
        uses: dci-labs/dci-component@v1
        with:
          dciClientId: ${{ secrets.DCI_CLIENT_ID }}
          dciApiSecret: ${{ secrets.DCI_API_SECRET }}
          dciTopics: "OCP-4.12"
          componentName: "My container application"
          componentVersion: v1.2.3
          componentRelease: "dev"
        id: dci

      - name: Results
        run: |
          echo "## DCI components" >> ${GITHUB_STEP_SUMMARY}
          echo "" >> ${GITHUB_STEP_SUMMARY}
          echo "\`\`\`JSON" >> ${GITHUB_STEP_SUMMARY}
          <<<'${{ steps.dci.outputs.components }}' jq . >> ${GITHUB_STEP_SUMMARY}
          echo "\`\`\`" >> ${GITHUB_STEP_SUMMARY}
          echo "" >> ${GITHUB_STEP_SUMMARY}
```

The Results step will take the markdown generated and render it nicely.

## Changelog

Please take a look at [CHANGELOG.md](./CHANGELOG.md)
