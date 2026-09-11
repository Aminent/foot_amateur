const express = require('express');
const { body } = require('express-validator');
const { auth } = require('../middleware/auth');
const { 
  getTeamChatMessages, 
  sendTeamMessage, 
  getTeamChatInfo, 
  markTeamMessagesAsRead, 
  getUnreadCount 
} = require('../controllers/chatController');

const router = express.Router();

// All routes require authentication
router.use(auth);

// Validation rules
const sendTeamMessageValidation = [
  body('message')
    .notEmpty()
    .withMessage('Message is required')
    .trim()
    .isLength({ min: 1, max: 1000 })
    .withMessage('Message must be between 1 and 1000 characters'),
  body('messageType')
    .optional()
    .isIn(['text', 'image', 'file'])
    .withMessage('Message type must be text, image, or file'),
  body('attachmentUrl')
    .optional()
    .isURL()
    .withMessage('Attachment URL must be a valid URL'),
];

const markAsReadValidation = [
  body('messageIds')
    .isArray({ min: 1 })
    .withMessage('Message IDs array is required'),
  body('messageIds.*')
    .isInt()
    .withMessage('Each message ID must be an integer'),
];

// Group chat routes
router.get('/messages', getTeamChatMessages);
router.post('/send', sendTeamMessageValidation, sendTeamMessage);
router.get('/info', getTeamChatInfo);
router.post('/mark-read', markAsReadValidation, markTeamMessagesAsRead);
router.get('/unread-count', getUnreadCount);

module.exports = router;
