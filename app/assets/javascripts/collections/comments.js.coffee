class Timecard.Collections.Comments extends Backbone.Collection
  url: '/comments'

  model: Timecard.Models.Comment

  countPluralizedName: ->
    return '' if @length is 0
    return "#{@length} comment" if @length is 1
    "#{@length} comments"
