// This mixin allows a route to open the composer
import Composer from 'nilavu/models/composer';

export default Ember.Mixin.create({

  openComposer(controller) {
    return this.controllerFor('composer').open({
      categoryId: controller.get('category.id'),
      action: Composer.CREATE_TOPIC,
      draftKey: controller.get('model.draft_key'),
      draftSequence: controller.get('model.draft_sequence')
    });
  },

  openComposerWithTopicParams(controller, topicTitle, topicBody, topicCategoryId, topicCategory) {
    this.controllerFor('composer').open({
      action: Composer.CREATE_TOPIC,
      topicTitle,
      topicBody,
      topicCategoryId,
      topicCategory,
      draftKey: controller.get('model.draft_key'),
      draftSequence: controller.get('model.draft_sequence')
    });
  },

  openComposerWithMessageParams(usernames, topicTitle, topicBody) {
    this.controllerFor('composer').open({
      action: Composer.PRIVATE_MESSAGE,
      usernames,
      topicTitle,
      topicBody,
      archetypeId: 'private_message',
      draftKey: 'new_private_message'
    });
  }

});
