export const EnvConfiguration = () => ({
  port: +process.env.PORT || 3000,
  rabbitMqUrl: process.env.RABBITMQ_URL ?? '',
});
