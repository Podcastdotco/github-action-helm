# github-action-helm
Run helm/kubectl command 

# Usage

See [action.yml](action.yml)

Basic:
```yaml
    steps:
      - name: Checkout helm
        uses: actions/checkout@v2
        with:
          repository: Podcastdotco/helm-charts
          token: ${{ secrets.CHECKOUT_TOKEN }}

      - id: github-actions-helm
        name: Helm upgrade
        uses: Podcastdotco/github-action-helm@master
        env:
          HELM_CHART: 'intercom-drip-archiver'
          HELM_ENVIRONMENT: 'staging'
          DOCKER_TAG: ${{needs.build.outputs.tag}}
        with:
          eksClusterName: 'podcast-staging'
          awsAccessKeyId: ${{ secrets.STAGING_AWS_ACCESS_KEY_ID }}
          awsSecretAccessKey: ${{ secrets.STAGING_AWS_SECRET_ACCESS_KEY }}
          awsDefaultRegion: 'us-east-1'
          command: |
            yq w -i ${HELM_CHART}/${HELM_ENVIRONMENT}.yaml container.tag ${DOCKER_TAG##*:}
            helm upgrade ${HELM_CHART} ${HELM_CHART} -f ${HELM_CHART}/${HELM_ENVIRONMENT}.yaml

            git config --global user.email "bob@podcast.co"
            git config --global user.name "Bob Builder"

            git add ${HELM_CHART}/${HELM_ENVIRONMENT}.yaml
            git commit -m "Deploying ${HELM_CHART} (${DOCKER_TAG##*:}) to ${HELM_ENVIRONMENT}" --allow-empty
            git push
```
