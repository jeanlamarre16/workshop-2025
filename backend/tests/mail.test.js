const request = require('supertest');
const app = require('../server');

describe('Hedwige API (mock)', () => {
  it('returns profile', async () => {
    const res = await request(app).get('/api/profile');
    expect(res.statusCode).toBe(200);
    expect(res.body.email).toBe('harry.potter@poudlard.edu');
  });

  it('lists messages', async () => {
    const res = await request(app).get('/api/messages');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body.messages)).toBe(true);
  });
});