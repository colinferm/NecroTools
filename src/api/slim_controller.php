<?php
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class SlimController {
	protected $container;

	public function __construct(ContainerInterface $container = null) {
		$this->container = $container;
	}
}
?>