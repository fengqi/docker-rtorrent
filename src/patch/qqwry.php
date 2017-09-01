<?php

class qqwry{
	public $file;
	public $fd;

	public $total;

	// 索引区
	public $index_start_offset;
	public $index_end_offset;

	public function __construct($file){
		if (!file_exists($file) or !is_readable($file)){
			throw new Exception("{$file} does not exist, or is not readable");
		}
		$this->file = $file;
		$this->fd = fopen($file, 'rb');

		$this->index_start_offset = join('', unpack('L', $this->read_offset(4, 0)));

		$this->index_end_offset = join('', unpack('L', $this->read_offset(4)));

		$this->total = ($this->index_end_offset - $this->index_start_offset)/7 + 1;
	}

	public function query($ip){
		$ip_split = explode('.', $ip);
		if (count($ip_split) !== 4){
			throw new Exception("{$ip} is not a valid ip address");
		}
		foreach ($ip_split as $v) {
			if ($v > 255){
				throw new Exception("{$ip} is not a valid ip address");
			}
		}
		$ip_num = $ip_split[0]*(256*256*256) + $ip_split[1]*(256*256) + $ip_split[2]*256 + $ip_split[3];
		$ip_find = $this->find($ip_num, 0, $this->total);
		$ip_offset = $this->index_start_offset+$ip_find*7+4;
		$ip_record_offset = $this->read_offset(3, $ip_offset);
		$ip_record_offset = join('', unpack('L', $ip_record_offset.chr(0)));
		return $this->read_record($ip_record_offset);
	}

	/**
	 * 读取记录
	 */
	public function read_record($offset){
		$record = array(0=>'', 1=>'');

		$offset = $offset + 4;

		$flag = ord($this->read_offset(1, $offset));

		if ($flag == 1){
			$location_offset = $this->read_offset(3, $offset+1);
			$location_offset = join('', unpack('L', $location_offset.chr(0)));

			$sub_flag = ord($this->read_offset(1, $location_offset));

			if ($sub_flag == 2){
				// 国家
				$country_offset = $this->read_offset(3, $location_offset+1);
				$country_offset = join('', unpack('L', $country_offset.chr(0)));
				$record[0] = $this->read_location($country_offset);
				// 地区
				$record[1] = $this->read_location($location_offset+4);
			} else {
				$record[0] = $this->read_location($location_offset);
				$record[1] = $this->read_location($location_offset+strlen($record[0])+1);
			}
		} else if ($flag == 2){
			// 地区
			// offset + 1(flag) + 3(country offset)
			$record[1] = $this->read_location($offset+4);

			// offset + 1(flag)
			$country_offset = $this->read_offset(3, $offset+1);
			$country_offset = join('', unpack('L', $country_offset.chr(0)));
			$record[0] = $this->read_location($country_offset);
		} else {
			$record[0] = $this->read_location($offset);
			$record[1] = $this->read_location($offset+strlen($record[0])+1);
		}
		return $record;
	}

	/**
	 * 读取地区
	 */
	public function read_location($offset){
		if ($offset == 0){
			return '';
		}

		$flag = ord($this->read_offset(1, $offset));

		// 出错
		if ($flag == 0){
			return '';
		}

		// 仍然为重定向
		if ($flag == 2){
			$offset = $this->read_offset(3, $offset+1);
			$offset = join('', unpack('L', $offset.chr(0)));
			return $this->read_location($offset);
		}

		$location = '';
		$chr = $this->read_offset(1, $offset);
		while(ord($chr) != 0){
			$location .= $chr;
			$offset++;
			$chr = $this->read_offset(1, $offset);
		}
		return $location;
	}

	/**
	 * 查找 ip 所在的索引
	 */
	public function find($ip_num, $l, $r){
		if ($l + 1 >= $r){
			return $l;
		}
		$m = intval(($l+$r)/2);

		$find = $this->read_offset(4, $this->index_start_offset+$m*7);
		$m_ip = join('', unpack('L', $find));

		if ($ip_num < $m_ip){
			return $this->find($ip_num, $l, $m);
		} else {
			return $this->find($ip_num, $m, $r);
		}
	}

	public function read_offset($number_of_bytes, $offset=null){
		if (!is_null($offset)){
			fseek($this->fd, $offset);
		}
		return fread($this->fd, $number_of_bytes);
	}

	public function inet_ntoa($nip){
		$ip = array();
		for ($i=3; $i > 0; $i--) { 
			$ip_seg = intval($nip/pow(256, $i));
			$ip[] = $ip_seg;
			$nip -= $ip_seg * pow(256, $i);
		}
		$ip[] = $nip;
		return join('.', $ip);
	}

	public function __destruct(){
		if ($this->fd){
			fclose($this->fd);
		}
	}

}
