class Sample extends Batman.App
  @resources 'tests'
  @root 'tests#index'

class Sample.Test extends Batman.Model
  @urlPrefix: '/api'
  @resourceName: 'tests'

  @persist Batman.RestStorage
  @searchAdapter Batman.SearchAdapter, url: '/api/tests'

  @encode 'name'

class Sample.TestsController extends Batman.Controller
  routingKey: 'tests'

  index: ->
    filters = [
      new Batman.Filter('Filtered', 'filtered',
                        {both: 'Both', filtered: 'Filtered', unfiltered: 'Unfiltered'},
                        'filtered')
    ]

    @set('paginator', new Batman.FilteredPaginator(Sample.Test, filters, limit: 2))

    @get('paginator').first (err, models) =>
      @set('models', models)

  next: ->
    @get('paginator').next (err, models) =>
      @set('models', models)

  prev: ->
    @get('paginator').prev (err, models) =>
      @set('models', models)

class Sample.TestsIndexView extends Batman.View
  html: '''
    <h4>Index View</h4>
    <ul>
      <li data-foreach-model="models">
        <div data-bind="model.name"></div>
      </li>
    </ul>
    <button data-event-click="prev">Prev</button>
    <button data-event-click="next">Next</button>
  '''

Batman.config.usePushState = false

window.Sample = Sample
Sample.run()
